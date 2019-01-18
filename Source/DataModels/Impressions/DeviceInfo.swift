//
//  Device.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 23/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import UIKit

struct DeviceInfo: Encodable {

	let ipAddress6: String
	let ipAddress4: String
	let altitude: Double
	let batteryLevel: Float
	let deviceModel: String
	let deviceOs: String
	let deviceVersion: String
	let horizontalAccuracy: Double
	let speed: Double
	let verticalAccuracy: Double

	init(ipAddress6: String = Utils.wiFiAddress.ip6,
	     ipAddress4: String = Utils.wiFiAddress.ip4,
	     batteryLevel: Float = UIDevice.current.batteryLevel,
	     deviceModel: String = UIDevice.current.model,
	     deviceOs: String = Constants.OS,
	     deviceVersion: String = UIDevice.current.systemVersion,
	     altitude: Double,
	     horizontalAccuracy: Double,
	     speed: Double,
	     verticalAccuracy: Double) {

		self.ipAddress6 = ipAddress6
		self.ipAddress4 = ipAddress4
		self.batteryLevel = batteryLevel
		self.deviceModel = deviceModel
		self.deviceOs = deviceOs
		self.deviceVersion = deviceVersion
		self.altitude = altitude
		self.horizontalAccuracy = horizontalAccuracy
		self.speed = speed
		self.verticalAccuracy = verticalAccuracy
	}
}
