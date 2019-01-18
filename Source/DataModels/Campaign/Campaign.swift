//
//  Campaign.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 14/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct Campaign: Decodable {
    
    struct Data: Decodable {
        let id: Int
        let campaignContentTouchId: Int?
        let campaignContentNearId: Int?
        let campaignContentFarId: Int?
        let campaignContent: CampaignContent
        let mediaCdn: String
        let impressionId: Int
    }
    
    let data: Data?
}
