//
//  IntecativeViewController.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 10/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

public protocol InteractiveController {
	var transitionPercentage: UIViewControllerInteractiveTransitioning { get }
	
	func prepareToPresent()
	func didFinishPresenting()
}
