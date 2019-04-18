//
//  WidgetsPresenter.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 12/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public protocol WidgetsPresenterDelegate: class {
	func present(widget: WidgetViewController)
}

class WidgetsPresenter {

	weak var delegate: WidgetsPresenterDelegate?

	static let shared = WidgetsPresenter()

	private init() {}

	private var isPresentingWidget: Bool {
		return UIApplication.shared.keyWindow?.topMostViewController is WidgetViewController
	}

    func presentWidget(withContent content: CampaignContent, callback: ((Bool) -> Void)? = nil) {

		guard !isPresentingWidget else { return }
        
		guard let widget = WidgetsAbstractFactory.widget(forCampaignContent: content) else {
			callback?(false)
			return
		}

		if let delegate = delegate {
			delegate.present(widget: widget)
			callback?(true)
			return
		}

		guard let topMostViewController = UIApplication.shared.keyWindow?.topMostViewController else {
			callback?(false)
			return
		}

		widget.modalPresentationStyle = .overCurrentContext

		topMostViewController.present(widget, animated: true) {
			callback?(true)
		}
	}
}
