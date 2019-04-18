//
//  MediaVideo.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 23/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct MediaVideo: Codable {
	let id: Int?
	let filename: String?
	let encodedFile: URL?
	let videoThumb: URL?
	let videoSthumb: URL?
	let duration: Double?
	let path: String?
	let mimetype: String?
	let filesize: Double?
	let title: String?
	let width: Double?
	let height: Double?
	let mediaStatus: String?
}
