//
//  LoginResponse.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 10/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct AWS: Decodable {
    let sns: String?
    let iosArn: String?
    let identityPoolId: String?
}

struct LoginResponse: Decodable {
    
    struct Data: Decodable {
        let appGuid: String?
        let refresh: String?
        let token: String?
        let kontaktApiKey: String?
        let aws: AWS?
        let message: String?
    }
    
    let data: Data
    let success: Bool
}
