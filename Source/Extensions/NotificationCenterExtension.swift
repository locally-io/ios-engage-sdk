// swiftlint:disable:this file_name
//
//  NotificationCenterExtension.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 29/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

extension NotificationCenter {

	enum Event {
		case enterOnBackground
	}

	static func observe(event: Event, observer: Any, selector: Selector) {
		switch event {
			case .enterOnBackground:
				self.default.addObserver(observer, selector: selector, name: UIApplication.didEnterBackgroundNotification, object: nil)
		}
	}
}
