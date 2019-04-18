// swiftlint:disable:this file_name
//
//  UIApplicationExtension.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 20/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

extension UIApplication {
	var isAppOnForeground: Bool {
		return self.applicationState == .active
	}
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
