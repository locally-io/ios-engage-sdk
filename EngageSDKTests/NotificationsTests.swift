//
//  NotificationsTests.swift
//  EngageSDKTests
//
//  Created by Rodolfo Pujol Luna on 12/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import PromiseKit
import XCTest

class NotificationsTests: XCTestCase {
 
    func testSuscribeRemoteNotifications() {
        let expectation = self.expectation(description: "remote notification")
        
        _ = NotificationServices.suscribeNotifications(deviceToken: "dcb68f1ccadc96aac67b90e3e04e883d0b1e6b79c0e78d09340f1e5885010a20")
            
            .done { _ in
                
                expectation.fulfill()
            }.catch { error in
                
                guard error is NetworkError else {
                    expectation.fulfill()
                    return
                }
                
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
