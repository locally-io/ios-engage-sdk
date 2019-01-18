//
//  RefreshTokenRequest.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 15/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct RefreshTokenRequest: Encodable {
	let refresh: String
	let deviceId: String
}
