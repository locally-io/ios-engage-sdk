//
//  MediaImage.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 23/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct MediaImage: Codable {
	let id: Int
	let filename: String
	let path: String
	let mimetype: String
	let filesize: Double
	let title: String?
	let description: String?
	let width: Double
	let height: Double
	let mediaStatus: String
	let url: String
}
