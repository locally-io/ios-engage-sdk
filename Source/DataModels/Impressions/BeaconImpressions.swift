//
//  Impressions.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 14/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct BeaconImpressions: Encodable {

	let uuid: String
	let deviceId: String
	let os: String
	let bluetoothEnabled: Bool
	let appName: String
	let type: ImpressionType
	let proximity: BeaconProximity
	let major: Int
	let minorDec: Int
	var lat: Double
	let lng: Double
	let timestamp: String
	let demographics: Demographics
	let deviceInfo: DeviceInfo

	init(uuid: String = Constants.UUID,
	     deviceId: String = Utils.deviceId ?? "",
	     os: String = Constants.OS,
	     appName: String = Utils.appName,
	     timestamp: String = Utils.formatedDate,
	     bluetoothEnabled: Bool,
	     type: ImpressionType,
	     proximity: BeaconProximity,
	     major: Int,
	     minor: Int,
	     age: Int,
	     gender: Gender,
	     location: Location) {

		self.uuid = uuid
		self.deviceId = deviceId
		self.os = os
		self.appName = appName
		self.timestamp = timestamp
		self.bluetoothEnabled = bluetoothEnabled
		self.type = type
		self.proximity = proximity
		self.major = major
		self.minorDec = minor
		self.lat = location.latitude
		self.lng = location.longitude

		self.demographics = Demographics(age: age, gender: gender)

		self.deviceInfo = DeviceInfo(altitude: location.altitude,
		                             horizontalAccuracy: location.horizontal,
		                             speed: location.speed,
		                             verticalAccuracy: location.vertical)
	}
}
