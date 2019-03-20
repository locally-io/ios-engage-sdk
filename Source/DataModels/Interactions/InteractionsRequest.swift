//
//  InteractionsRequest.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 12/03/19.
//  Copyright © 2019 Locally. All rights reserved.
//

import Foundation

struct InteractionsRequest: Encodable {
    let campaignId: Int
    let impressionId: Int
    let deviceId: String
    let action: Action
    let timestamp: String
}
