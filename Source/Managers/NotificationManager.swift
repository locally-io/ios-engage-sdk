//
//  CampaignNotifier.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 12/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import AWSSNS
import Foundation
import PromiseKit
import UserNotifications

// MARK: - Notification Manager Errors

enum NotificationManagerError: String, Error {
    case notificationWasNotAuthorized = "Notification request was not authorized"
    case awsSubscribeInput = "AWS Subscribe Input could not created"
    case identityPoolIdCouldNotBeFound = "The cognito identityPoolId could not be found"
}

// MARK: - Notification Content

struct NotificationContent {
    let title: String
    let data: [AnyHashable: Any]
}

class NotificationManager: NSObject {
    
    private let category = "EngageNotification"
    private let contentKey = "NotificationManagerContentKey"
    
    // MARK: - Public Properties
    
    var deviceToken: Data? {
        didSet {
            guard let deviceToken = deviceToken, let sns = ConfigurationKeys.aws?.sns else { return }
            let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            subscribeToSNS(withDeviceToken: deviceTokenString, sns: sns)
        }
    }
    
    static var delegate: UNUserNotificationCenterDelegate? {
        didSet {
            guard delegate != nil else { return }
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
    
    // MARK: - Initialization
    
    static let shared = NotificationManager()
    
    override private init() {}
    
    // MARK: - Public API
    
    @discardableResult
    func sendNotification(withContent content: NotificationContent) -> Promise<Void> {
        
        return firstly {
            requestNotificationPermissions()
        }.then {
                self.createNotificationRequest(withContent: content)
        }
    }
    
    // MARK: - Internal Operations
    
    func requestNotificationPermissions() -> Promise<Void> {
        
        return Promise { seal in
            
            notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { _, error in
                
                guard let error = error else {
                    DispatchQueue.main.async {
                        guard !UIApplication.shared.isRegisteredForRemoteNotifications else {
                            seal.fulfill(())
                            return
                        }
                        
                        let category = UNNotificationCategory(identifier: self.category, actions: [], intentIdentifiers: [], options: [])
                        self.notificationCenter.setNotificationCategories([category])
                        
                        UIApplication.shared.registerForRemoteNotifications()
                        
                        seal.fulfill(())
                    }
                    return
                }
                
                seal.reject(error)
            }
        }
    }
    
    func createNotificationRequest(withContent notificationContent: NotificationContent) -> Promise<Void> {
        
        return Promise { seal in
            
            notificationCenter.getNotificationSettings { settings in
                
                guard settings.authorizationStatus == UNAuthorizationStatus.authorized else {
                    seal.reject(NotificationManagerError.notificationWasNotAuthorized)
                    return
                }
                
                let content = UNMutableNotificationContent()
                content.title = notificationContent.title
                content.userInfo = notificationContent.data
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                self.notificationCenter.add(request, withCompletionHandler: nil)
                
                seal.fulfill(())
            }
        }
    }
    
    // MARK: - Private Operations
    
    private func subscribeToSNS(withDeviceToken deviceToken: String, sns: String) {
        
        Log.print(title: "NotificationManager - Device Token", message: deviceToken)
        
        let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
        
        firstly {
            NotificationServices.getArnEndPoint(deviceToken: deviceToken)
        }.then(on: backgroundQueue) { response -> Promise<AWSSNSSubscribeResponse> in
                self.subscribeToAWS(withSNS: sns, andEndPoint: response.data.EndpointArn)
        }.done { response in
                guard let arnSubscription = response.subscriptionArn else { return }
                Log.print(title: "NotificationManager - Success Subscription", message: "To \(arnSubscription)")
        }.catch { error in
                Log.print(title: "NotificationManager - Error", message: error.localizedDescription)
        }
    }
    
    private func authenticateToAWS() {
        
        guard let identityPoolId = ConfigurationKeys.aws?.identityPoolId else {
            print(NotificationManagerError.identityPoolIdCouldNotBeFound)
            return
        }
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: identityPoolId)
        let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    private func subscribeToAWS(withSNS sns: String, andEndPoint endpoint: String) -> Promise<AWSSNSSubscribeResponse> {
        
        authenticateToAWS()
        
        return Promise<AWSSNSSubscribeResponse> { promise in
            
            guard let subscribeInput = AWSSNSSubscribeInput() else {
                promise.reject(NotificationManagerError.awsSubscribeInput)
                return
            }
            
            subscribeInput.topicArn = sns
            subscribeInput.protocols = "application"
            subscribeInput.endpoint = endpoint
            
            AWSSNS.default().subscribe(subscribeInput) { response, error in
                switch (response, error) {
                case (let response?, _):
                    promise.fulfill(response)
                case (_, let error?):
                    promise.reject(error)
                default: break
                }
            }
        }
    }
    
    private lazy var notificationCenter: UNUserNotificationCenter = {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        return notificationCenter
    }()
    
    private func handleRemoteNotification(notification: UNNotification) {
        guard let remoteNotification = RemoteNotification.fromDictionary(dictionary: notification.request.content.userInfo) else { return }
        guard let link = remoteNotification.locally.link, let url = URL(string: link) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        let content = CampaignContent.fromDictionary(dictionary: userInfo)
        
        switch (content, UIApplication.shared.isAppOnForeground) {
        case (let content?, true):
            WidgetsPresenter.shared.presentWidget(withContent: content)
        case (let content?, false):
            completionHandler(UNNotificationPresentationOptions.alert)
            WidgetsPresenter.shared.presentWidget(withContent: content)
        case (_, _):
            completionHandler(UNNotificationPresentationOptions.alert)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        
        let userInfo = response.notification.request.content.userInfo
        
        if let campaignContent = CampaignContent.fromDictionary(dictionary: userInfo) {
            WidgetsPresenter.shared.presentWidget(withContent: campaignContent)
        } else {
            handleRemoteNotification(notification: response.notification)
        }
    }
}
