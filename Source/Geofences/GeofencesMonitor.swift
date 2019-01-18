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

	func startMonitoring() {
		LocationManager.startMonitoring(delegate: self)
	}

	func stopMonitoring() {
		LocationManager.stopMonitoring()
	}
}

extension GeofencesMonitor: LocationManagerDelegate {

	func didChangeLocation(location: CLLocation) {
		
		let geofencesRequest = GeofencesRequest(isBluetoothEnabled: Utils.isBluetoothEnabled, location: Location(location: location))
		
		_ = GeofencesServices.getGeofences(geofencesRequest: geofencesRequest).done { campaign in
			guard let campaignContent = campaign.data?.campaignContent, let data = campaignContent.toDictionary() else { return }
			let content = NotificationContent(title: campaignContent.name, data: data)
			NotificationManager.shared.sendNotification(withContent: content)
		}.catch { error in
			Log.print(title: "GeofencesServices - Error", message: error.localizedDescription)
		}
	}
}
