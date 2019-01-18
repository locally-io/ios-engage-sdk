//
//  LocationRequest.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol on 21/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreLocation
import Foundation

struct Location {

	let longitude: Double
	let latitude: Double
	let altitude: Double
	let horizontal: Double
	let speed: Double
	let vertical: Double

	init(location: CLLocation) {
		self.longitude = location.coordinate.longitude
		self.latitude = location.coordinate.latitude
		self.altitude = location.altitude
		self.horizontal = location.altitude
		self.speed = location.speed
		self.vertical = location.verticalAccuracy
	}

	init(longitude: Double, latitude: Double, altitude: Double, horizontal: Double, speed: Double, vertical: Double) {
		self.longitude = longitude
		self.latitude = latitude
		self.altitude = altitude
		self.horizontal = horizontal
		self.speed = speed
		self.vertical = vertical
	}
}
