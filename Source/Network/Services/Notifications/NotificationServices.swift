//
//  NotificationServices.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 12/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

enum NotificationServicesError: Error {
	case deviceIdCouldNotBeFound
}

class NotificationServices: AuthorizedService {

	static func getArnEndPoint(deviceToken: String) -> Promise<NotificationResponse> {

		guard let deviceId = Utils.deviceId else {
			return Promise<NotificationResponse>.init(error: NotificationServicesError.deviceIdCouldNotBeFound)
		}

		let request = NotificationRequest(deviceId: deviceId, os: Constants.OS, deviceToken: deviceToken)

		return postAuthorized(url: "\(URLS.base)/apps/push_subscribe.json", requestData: request)
	}
}
