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
}
