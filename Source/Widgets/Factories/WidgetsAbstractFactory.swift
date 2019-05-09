//
//  WidgetsAbstractFactory.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 5/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

public protocol WidgetContent {}

public protocol Widget {
	var content: WidgetContent? { get set }
    var id: Int? { get set }
	var didDismiss: (() -> Void)? { get set }
    
    func present() -> Bool
}

public typealias WidgetViewController = UIViewController & Widget

protocol WidgetFactory {
    static func widget(fromContent content: CampaignContent) -> WidgetViewController?
}

class WidgetsAbstractFactory {

	private init() {}

	static func widget(forCampaignContent content: CampaignContent) -> WidgetViewController? {
        guard let layout = content.layout else { return nil }
        
        switch layout {
        case "MISC":
            return MiscellaneousFactory.widget(fromContent: content)
        case "COUPONS":
            return CouponsFactory.widget(fromContent: content)
        case "SURVEY":
            return nil
        case "PUSH_NOTIFICATION":
            return PushNotificationsFactory.widget(fromContent: content)
        //case .RETAIL:
        //    return nil
        default:
            return nil
        }
	}
}
