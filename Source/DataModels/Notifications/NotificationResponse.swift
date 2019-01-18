//
//  NotificationResponse.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 12/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct NotificationResponse: Decodable {

    struct Data: Decodable {
		// swiftlint:disable:next identifier_name
        let EndpointArn: String
    }
    
    let data: Data
}
