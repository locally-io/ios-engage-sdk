//
//  CampaignsCoordinator.swift
//  EngageSDK,,,
//
//  Created by Eduardo Dias on 12/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreLocation
import Foundation
import PromiseKit
import UserNotifications

struct Cache: Equatable, Hashable {
    let beaconProximity: BeaconProximity
    let campaignContentId: Int?
}

class CampaignsCoordinator {
    
    private var cached: Set<Cache> = []
    private var cachedNotification: Set<Cache> = []
    
    func requestCampaigns(forBeacons beacons: [Beacon]) -> Promise<[Campaign]> {
        
        let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
        let state = UIApplication.shared.applicationState
        return firstly {
            LocationManager.currentLocation
        }.then(on: backgroundQueue) { location -> Guarantee<[Result<Campaign>]> in
                let campaignRequests = beacons.map { self.requestCampaign(withBeacon: $0, andLocation: location) }
                
                return when(resolved: campaignRequests)
        }.then(on: backgroundQueue) { campaignResults -> Promise<[Campaign]> in
                let campaigns = campaignResults.enumerated().compactMap { self.campaign(withBeacon: beacons[$0.offset],
                                                                                        andResult: $0.element, state: state)
                }
                return Promise<[Campaign]>.value(campaigns)
        }
    }
    
    private func requestCampaign(withBeacon beacon: Beacon, andLocation location: CLLocation) -> Promise<Campaign> {
        let location = Location(location: location)
        ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .beaconRequest, beacon: beacon))
        let campaignRequest = CampaignRequest(isBluetoothEnabled: Utils.isBluetoothEnabled, location: location, beacon: beacon)
        return CampaignServices.getCampaign(campaignRequest: campaignRequest)
    }
    
    private func campaign(withBeacon beacon: Beacon, andResult result: Result<Campaign>, state: UIApplication.State) -> Campaign? {
        
        switch result {
        case .fulfilled(let campaign):
            
            guard let campaignContent = campaign.data?.campaignContent else { return nil }
            
            let cache = Cache(beaconProximity: beacon.proximity, campaignContentId: campaignContent.id)
            guard state == .active || !self.cachedNotification.contains(cache) else { return nil }
            
            self.cachedNotification.insert(cache)
            
            return campaign
        case .rejected:
            return nil
        }
    }
}

extension CampaignsCoordinator: BeaconsListener, Hashable {
    
    // swiftlint:disable:next legacy_hashing
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    static func == (lhs: CampaignsCoordinator, rhs: CampaignsCoordinator) -> Bool {
        return lhs === rhs
    }
    
    func clearCache() {
        cached = []
    }
    
    func didFindBeacons(beacons: [Beacon]) {
        
        _ = requestCampaigns(forBeacons: beacons).done { campaigns in
            
            let contents = campaigns.compactMap { campaign -> NotificationContent? in
                
                guard let campaignData = campaign.data else { return nil }
                let impressionId = campaignData.impressionId
                let campaignId = campaignData.id
                
                guard let content = campaign.data?.campaignContent else { return nil }
                
                content.campaignContentButtons.forEach { button in
                    button.campaignId = campaignId
                    button.impressionId = impressionId
                }
                
                guard let data = content.toDictionary() else { return nil }
                
                return NotificationContent(title: content.notificationMessage, data: data)
            }
            
            guard !contents.isEmpty else { return }
            
            contents.forEach {
                ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .beaconResponse, forCampaign: $0.title))
                NotificationManager.shared.sendNotification(withContent: $0)
            }
        }
    }
}
