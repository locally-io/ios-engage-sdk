// swiftlint:disable:this file_name
//
//  UIViewLayoutExtension.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 15/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

extension UIView {

	var x: CGFloat {
		get {
			return frame.origin.x
		}
		set {
			frame = CGRect(x: newValue, y: y, width: width, height: height)
		}
	}

	var y: CGFloat {
		get {
			return frame.origin.y
		}
		set {
			frame = CGRect(x: x, y: newValue, width: width, height: height)
		}
	}

	var width: CGFloat {
		get {
			return frame.size.width
		}
		set {
			frame = CGRect(x: x, y: y, width: newValue, height: height)
		}
	}

	var halfWidth: CGFloat {
		return frame.size.width / 2
	}

	var height: CGFloat {
		get {
			return frame.size.height
		}
		set {
			frame = CGRect(x: x, y: y, width: width, height: newValue)
		}
	}

	var halfHeight: CGFloat {
		return frame.size.height / 2
	}
}
