//
//  InteractionServices.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 12/03/19.
//  Copyright © 2019 Locally. All rights reserved.
//

import Foundation
import PromiseKit

public class InteractionServices: AuthorizedService {
    static func sendInteraction(request: InteractionsRequest) -> Promise<InteractionsResponse> {
        return postAuthorized(url: "\(URLS.base)/interactions/register.json", requestData: request)
    }
}
