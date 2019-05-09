//
//  CampaignContent.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol on 21/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

public struct CampaignContent: Codable, DictionaryConvertible {

	enum Layout: String, Decodable, Encodable {
		case MISC, COUPONS, SURVEY, PUSHNOTIFICATION = "PUSH_NOTIFICATION"//, RETAIL
	}

	struct Attributes: Codable {
		let message: String
        let pushMessage: String?
        let link: String?
		let submit: String
		let backgroundGradientTop: String
		let backgroundGradientBottom: String
		let textColor: String
	}

	let id: Int
    let impressionId: Int?
	let name: String
	let description: String
	let notificationMessage: String
	let layout: String?
	let subLayout: String
	let checkVideo: String
	let checkImage: String
	let headerTitle: String
	let videoDescriptionText: String
	let productName: String?
	let productDescription: String?
	let productPrice: Double?
	let interactionMethod: String
    let qrCodeImageUrl: String?
	let attributes: Attributes?
	let survey: SurveyResponse?
	let campaignContentActions: [InteractiveContent]
	let campaignContentButtons: [InteractiveContent]
	let mediaVideo: MediaVideo?
	let mediaImage: MediaImage?
}
