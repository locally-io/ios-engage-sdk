//
//  CampaignRequest.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 12/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct CampaignRequest {
	let age: Int = 0
	let gender: Gender = .Male
	let isBluetoothEnabled: Bool
	let location: Location
	let beacon: Beacon
}
