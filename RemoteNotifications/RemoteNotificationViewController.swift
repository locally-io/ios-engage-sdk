//
//  RemoteNotificationsViewController.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 20/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import AlamofireImage
import UIKit
import UserNotifications
import UserNotificationsUI

public class RemoteNotificationViewController: UIViewController, UNNotificationContentExtension {

	@IBOutlet private var imageView: UIImageView!

	public func didReceive(_ notification: UNNotification) {

		guard let notification = RemoteNotification.fromDictionary(dictionary: notification.request.content.userInfo) else { return }

		guard let imageUrlString = notification.locally.image, let imageUrl = URL(string: "\(imageUrlString)?h=500") else { return }

		imageView.af_setImage(withURL: imageUrl)
	}
}
