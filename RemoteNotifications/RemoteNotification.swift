//
//  RemoteNotification.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 19/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct RemoteNotification: Codable, DictionaryConvertible {

	struct Locally: Codable {
		let title: String?
		let message: String?
		let image: String?
		let link: String?
	}

	let locally: Locally
}
