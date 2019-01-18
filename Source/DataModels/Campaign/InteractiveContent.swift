//
//  CampaignInteractiveContent.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 8/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct InteractiveContent: Codable {

	enum Action: String, Codable {
		case openUrl   = "OPEN_URL"
		case phoneCall = "PHONE_CALL"
		case sendEmail = "SEND_EMAIL"
		case openMap   = "OPEN_MAP"
		case playVideo = "PLAY_VIDEO"
		case noAction  = "NO_ACTION"
	}

	let id: Int
	let campaignContentId: Int
	let videoId: Int?
	let action: Action
	let data: String
	let color: String?
	let label: String?
	let created: Date
	let modified: Date
}
