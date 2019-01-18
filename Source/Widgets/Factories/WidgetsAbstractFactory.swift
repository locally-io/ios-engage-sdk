//
//  WidgetsAbstractFactory.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 5/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

protocol WidgetContent {}

protocol Widget {
	var content: WidgetContent? { get set }
}

typealias WidgetViewController = UIViewController & Widget

protocol WidgetFactory {
	static func widget(fromContent content: CampaignContent) -> WidgetViewController?
}

class WidgetsAbstractFactory {

	private init() {}

	static func widget(forCampaignContent content: CampaignContent) -> WidgetViewController? {

		switch content.layout {

			case .MISC:
				return MiscellaneousFactory.widget(fromContent: content)
			case .COUPONS:
				return nil
			case .SURVEY:
				return nil
		}
	}
}
