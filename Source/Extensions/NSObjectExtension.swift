// swiftlint:disable:this file_name
//
//  NSObjectExtension.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 11/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

enum NSObjectExtensionError: String, Error {
	case couldNotFindClass = "Could not find class name"
}

extension NSObject {

	public class var className: String {
		return String(describing: self).components(separatedBy: ".").last ?? NSObjectExtensionError.couldNotFindClass.rawValue
	}

	public var className: String {
		return String(describing: self).components(separatedBy: ".")
			.last?.components(separatedBy: ":")
			.first ?? NSObjectExtensionError.couldNotFindClass.rawValue
	}
}
