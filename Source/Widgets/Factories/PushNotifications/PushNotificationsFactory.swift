//
//  PushNotificationsFactory.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 18/04/19.
//  Copyright © 2019 Locally. All rights reserved.
//

import Foundation
import UserNotifications

struct RichPushContent: WidgetContent {
    let imageUrl: String?
    let imageName: String?
    let title: String?
    let subtitle: String?
    let body: String?
    let category: String
    let link: String?
    let interactiveContents: [InteractiveContent]?
}

extension CampaignContent {
    var richPushContent: RichPushContent {
        return RichPushContent(imageUrl: mediaImage?.url, imageName: mediaImage?.filename, title: headerTitle, subtitle: attributes?.pushMessage,
                               body: attributes?.message, category: String(id), link: attributes?.link, interactiveContents: campaignContentButtons)
    }
}
class PushNotificationsFactory: WidgetFactory {
    private static let xibFactory = "Coupon"
    
    private enum PushNotificationLayout: String {
        case richPush = "e_rich_push_notification"
    }
    
    static func widget(fromContent content: CampaignContent) -> WidgetViewController? {
        switch content.subLayout {
        case PushNotificationLayout.richPush.rawValue:
            
            createRichPushNotification(fromContent: content)
            return nil
        default:
            return nil
        }
    }
    
    static func createRichPushNotification(fromContent content: CampaignContent) {
        let ncontent = UNMutableNotificationContent()
        ncontent.title = content.richPushContent.title ?? ""
        ncontent.body = content.richPushContent.subtitle ?? ""
        ncontent.categoryIdentifier = content.richPushContent.category
        
        guard let url = URL(string: content.richPushContent.imageUrl ?? "") else { return }
        
        guard let imageName = content.richPushContent.imageName else { return }
        
        guard let imageData = NSData(contentsOf: url) else {
            return
        }
        
        if let attachment = UNNotificationAttachment.saveImage(withName: imageName, data: imageData) {
            ncontent.attachments = [attachment]
        }
        
        if let link = content.richPushContent.link {
            ncontent.userInfo = ["linkpush": link ]
        }
        
        let categoryName = content.richPushContent.category
        
        let category = UNNotificationCategory(identifier: categoryName, actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: categoryName, content: ncontent, trigger: trigger)
        
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
