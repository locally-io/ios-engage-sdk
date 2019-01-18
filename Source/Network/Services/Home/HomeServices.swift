//
//  HomeServices.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 18/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

class HomeServices: AuthorizedService {

	static func getScreens(guid: String) -> Promise<ScreensResponse> {
		return getAuthorized(url: "\(URLS.base)/apps/screens/\(guid).json")
	}
}
