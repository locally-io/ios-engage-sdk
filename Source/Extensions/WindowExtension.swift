// swiftlint:disable:this file_name
//
//  WindowExtension.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 12/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

extension UIWindow {

	var topMostViewController: UIViewController? {
		guard let rootViewController = self.rootViewController else { return nil }
		return topViewController(for: rootViewController)
	}

	func topViewController(for rootViewController: UIViewController) -> UIViewController? {

		guard let presentedViewController = rootViewController.presentedViewController else { return rootViewController }

		switch presentedViewController {

			case let navigationController as UINavigationController:
				guard let lastViewController = navigationController.viewControllers.last else { return nil }
				return topViewController(for: lastViewController)
			case let tabBarController as UITabBarController:
				guard let selectedViewController = tabBarController.selectedViewController else { return nil }
				return topViewController(for: selectedViewController)
			default:
				return topViewController(for: presentedViewController)
		}
	}
}
