//
//  CampaignsCoordinator.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 12/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreLocation
import Foundation
import PromiseKit
import UserNotifications

class CampaignsCoordinator {

	func requestCampaigns(forBeacons beacons: [Beacon]) -> Promise<[Campaign]> {

		let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

		return firstly {
			LocationManager.currentLocation
		}.then(on: backgroundQueue) { location -> Guarantee<[Result<Campaign>]> in
			let campaignRequests = beacons.map { self.requestCampaign(withBeacon: $0, andLocation: location) }
			return when(resolved: campaignRequests)
		}.then(on: backgroundQueue) { campaignResults -> Promise<[Campaign]> in
			let campaigns = campaignResults.compactMap { self.campaign(fromResult: $0) }
			return Promise<[Campaign]>.value(campaigns)
		}
	}

	private func requestCampaign(withBeacon beacon: Beacon, andLocation location: CLLocation) -> Promise<Campaign> {
		let location = Location(location: location)
		let campaignRequest = CampaignRequest(isBluetoothEnabled: Utils.isBluetoothEnabled, location: location, beacon: beacon)
		return CampaignServices.getCampaign(campaignRequest: campaignRequest)
	}

	private func campaign(fromResult result: Result<Campaign>) -> Campaign? {

		switch result {
			case .fulfilled(let campaign):
				return campaign
			case .rejected:
				return nil
		}
	}
}

extension CampaignsCoordinator: BeaconsListener, Hashable {

	public var hashValue: Int {
		return ObjectIdentifier(self).hashValue
	}

	static func == (lhs: CampaignsCoordinator, rhs: CampaignsCoordinator) -> Bool {
		return lhs === rhs
	}

	func didFindBeacons(beacons: [Beacon]) {

		_ = requestCampaigns(forBeacons: beacons).done { campaigns in

			let contents = campaigns.compactMap { campaign -> NotificationContent? in
				guard let content = campaign.data?.campaignContent, let data = content.toDictionary() else { return nil }
				return NotificationContent(title: content.name, data: data)
			}

			guard !contents.isEmpty else { return }

			contents.forEach { NotificationManager.shared.sendNotification(withContent: $0) }
		}
	}
}
