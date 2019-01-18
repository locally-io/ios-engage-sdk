// swiftlint:disable:this file_name
//
//  ViewControllerExtension.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 11/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

extension UIViewController {

	static func fromNib<ViewController: UIViewController>(nibName: String? = nil) -> ViewController {

		let nibName = nibName ?? self.className

		let sdkBundle = Bundle(for: self)

		guard sdkBundle.path(forResource: nibName, ofType: "nib") != nil else {
			fatalError("Nib \(nibName) doesn't exist on bundle \(sdkBundle)")
		}

		let nib = UINib(nibName: nibName, bundle: sdkBundle).instantiate(withOwner: nil, options: nil)

		guard let viewControllers = nib as? [ViewController] else {
			fatalError("Nib \(nibName) do not have view controllers")
		}

		guard let viewController = viewControllers.first(where: { $0.className == self.className }) else {
			fatalError("Nib \(className) could not find view controller")
		}

		return viewController
	}
}
