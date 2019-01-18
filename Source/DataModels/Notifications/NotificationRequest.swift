//
//  NotificationRequest.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 12/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct NotificationRequest: Encodable {
	
    let deviceId: String
    let os: String
    let deviceToken: String
    
    init(deviceId: String, os: String, deviceToken: String) {
        self.deviceId = deviceId
        self.os = os
        self.deviceToken = deviceToken
    }
}
