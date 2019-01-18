// swiftlint:disable:this file_name
//
//  UNNotificationAttachmentExtension.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 20/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UserNotifications

extension UNNotificationAttachment {

	static func saveImage(withName imageName: String, data: NSData) -> UNNotificationAttachment? {

		let folderName = ProcessInfo.processInfo.globallyUniqueString

		guard let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true) else { return nil }

		let fileURL = folderURL.appendingPathComponent(imageName)

		do {
			try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
			try data.write(to: fileURL, options: [])
			return try UNNotificationAttachment(identifier: imageName, url: fileURL, options: nil)
		} catch let error {
			Log.print(title: "UNNotificationAttachment - Saving Image Error!", message: error.localizedDescription)
		}

		return nil
	}
}
