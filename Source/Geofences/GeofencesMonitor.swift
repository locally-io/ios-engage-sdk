//
//  GeofencesMonitor.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 27/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreLocation
import Foundation
import PromiseKit
import UIKit

class GeofencesMonitor {
    
    var contents = [CampaignContent]()
    var contentsNotification = [CampaignContent]()
    var timer: Timer?
    var sendRequest = true
    let scanInterval = 5.0
    
    func startMonitoring() {
        //clearCache()
        LocationManager.startMonitoring(delegate: self)
        timer = Timer.scheduledTimer(withTimeInterval: scanInterval, repeats: true) { _ in
            self.sendRequest = true
        }
    }
    
    func initMonitoring() {
        LocationManager.startMonitoring(delegate: self)
    }
    
    func stopMonitoring() {
        LocationManager.stopMonitoring()
    }
    
    func clearCache() {
        contents = [CampaignContent]()
        contentsNotification = [CampaignContent]()
    }
}

extension GeofencesMonitor: LocationManagerDelegate {
    
    func didChangeLocation(location: CLLocation) {
        
        guard sendRequest else {return }
        
        sendRequest = false
        let geofencesRequest = GeofencesRequest(isBluetoothEnabled: Utils.isBluetoothEnabled, location: Location(location: location))
        ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .geofenceRequest, location: location))
        _ = GeofencesServices.getGeofences(geofencesRequest: geofencesRequest).done { result in
            
            guard let data = result.data, let campaigns = data.campaigns else { return }
            let impressionId = data.impressionId
            
            campaigns.forEach { campaign in
                
                let campaignId = campaign.id
                guard let campaignContent = campaign.campaignContent else { return }
                
                campaignContent.campaignContentButtons.forEach { button in
                    button.campaignId = campaignId
                    button.impressionId = impressionId
                }
                
                guard let dataContent = campaignContent.toDictionary() else { return }
                
                ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .geofenceResponse, forCampaign: campaignContent.headerTitle ))
                
                guard self.showContent(campaign: campaignContent, isActive: UIApplication.shared.applicationState == .active) else {
                    return
                }
                
                let content = NotificationContent(title: campaignContent.notificationMessage, data: dataContent)
                NotificationManager.shared.sendNotification(withContent: content)
            }
        }.catch { error in
                Log.print(title: "GeofencesServices - Error", message: error.localizedDescription)
        }
    }
    
    func showContent(campaign: CampaignContent, isActive: Bool) -> Bool {
        
        let existsInNotifications = self.contentsNotification.filter { cContent -> Bool in
            cContent.id == campaign.id
        }
        
        if existsInNotifications.isEmpty {
            contentsNotification.append(campaign)
        }
        
        let existsInContent = self.contents.filter { cContent -> Bool in
            cContent.id == campaign.id
        }
        
        if existsInContent.isEmpty && isActive {
            contents.append(campaign)
        }
        
        let showContent = isActive ? existsInContent.isEmpty : existsInNotifications.isEmpty
        
        return showContent
    }
}
