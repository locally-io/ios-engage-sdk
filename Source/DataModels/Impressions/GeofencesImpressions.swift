//
//  GeofencesImpressions.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 3/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct GeofencesImpressions: Encodable {

	let deviceId: String
	let os: String
	let bluetoothEnabled: Bool
	let appName: String
	let proximity: GeofencesProximity
	var lat: Double
	let lng: Double
	let timestamp: String
	let demographics: Demographics
	let deviceInfo: DeviceInfo

	init(deviceId: String = Utils.deviceId ?? "",
	     os: String = Constants.OS,
	     appName: String = Utils.appName,
	     timestamp: String = Utils.formatedDate,
	     bluetoothEnabled: Bool,
	     proximity: GeofencesProximity,
	     age: Int,
	     gender: Gender,
	     location: Location) {

		self.deviceId = deviceId
		self.os = os
		self.appName = appName
		self.timestamp = timestamp
		self.bluetoothEnabled = bluetoothEnabled
		self.proximity = proximity
		self.lat = location.latitude
		self.lng = location.longitude

		self.demographics = Demographics(age: age, gender: gender)

		self.deviceInfo = DeviceInfo(altitude: location.altitude,
		                             horizontalAccuracy: location.horizontal,
		                             speed: location.speed,
		                             verticalAccuracy: location.vertical)
	}
}
