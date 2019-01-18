//
//  Beacon.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 23/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import KontaktSDK

struct Beacon: Hashable, CustomStringConvertible {
	
	let type: ImpressionType
	let proximity: BeaconProximity
	let major: Int
	let minorDec: Int
    
    init(type: ImpressionType, proximity: BeaconProximity, major: Int, minorDec: Int) {
        self.type = type
        self.proximity = proximity
        self.major = major
        self.minorDec = minorDec
    }
    
	init(beacon: CLBeacon) {
		proximity = Beacon.proximity(clProximity: beacon.proximity)
		type     = .beacon
		major    = beacon.major.intValue
		minorDec = beacon.minor.intValue
	}

	private static func proximity(clProximity: CLProximity) -> BeaconProximity {

		switch clProximity {
			case .far, .unknown:
				return .far
			case .near:
				return .near
			case .immediate:
				return .touch
		}
	}

	static func == (lhs: Beacon, rhs: Beacon) -> Bool {
		return lhs.major == rhs.major && lhs.minorDec == rhs.minorDec && lhs.proximity == rhs.proximity
	}

	var description: String {
		return "{ minor: \(minorDec), major: \(major), proximity: \(proximity) }"
	}
}
