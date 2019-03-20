//
//  InteractionsResponse.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 12/03/19.
//  Copyright © 2019 Locally. All rights reserved.
//

import Foundation

struct InteractionsResponse: Decodable {
    
    struct Interaction: Decodable {
        let clientId: Int?
        let interactionId: Int?
        let impressionId: Int?
        let pricingId: Int?
        let created: String?
        let modified: String?
        let id: Int?
    }
    
    let success: Bool
}
