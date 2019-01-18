//
//  Screen.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 18/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

public struct Screen: Decodable {
	public let image: String
	public let title: String
	public let content: String
	public let link: String
	public let screenOrder: String
}

struct ScreensResponse: Decodable {
	let data: [Screen]
}
