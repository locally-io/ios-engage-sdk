//
//  RemoteNotificationPreviewDisplayer.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 20/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UserNotifications

enum PreviewDisplayerError: String, Error {
	case contentCanNotBeMutable = "Request content could not be converted to mutable content"
	case notificatonCouldNotSerialized = "Remote notificaton could not be converted to dictionary"
	case imageUrlWasNotProvided = "Image url was not provied or is invalid"
	case imageCouldNotBeSaved = "Image could not be saved on disk"
}

public class RemoteNotificationPreviewDisplayer {

	private init() {}

	private static let notificationPreviewName = "remoteNotificationPreview.jpg"

	public class func displayPreview(withNotificationRequest request: UNNotificationRequest, andHandler handler: ((UNNotificationContent) -> Void)) {

		guard let mutableContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
			Log.print(title: "PreviewDisplayerError", message: PreviewDisplayerError.contentCanNotBeMutable.rawValue)
			return
		}

		guard let notification = RemoteNotification.fromDictionary(dictionary: request.content.userInfo) else {
			Log.print(title: "PreviewDisplayerError", message: PreviewDisplayerError.notificatonCouldNotSerialized.rawValue)
			return
		}

		guard let imageUrlString = notification.locally.image, let imageUrl = URL(string: "\(imageUrlString)?w=100") else {
			Log.print(title: "PreviewDisplayerError", message: PreviewDisplayerError.imageUrlWasNotProvided.rawValue)
			return
		}

		guard let imageData = NSData(contentsOf: imageUrl) else {
			handler(mutableContent)
			return
		}

		guard let attachment = UNNotificationAttachment.saveImage(withName: notificationPreviewName, data: imageData) else {
			Log.print(title: "PreviewDisplayerError", message: PreviewDisplayerError.imageCouldNotBeSaved.rawValue)
			handler(mutableContent)
			return
		}

		mutableContent.attachments = [ attachment ]

		handler(mutableContent)
	}
}
