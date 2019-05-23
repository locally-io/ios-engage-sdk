//
//  WidgetCoordinatorTests.swift
//  EngageSDKTests
//
//  Created by Eduardo Dias on 16/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import PromiseKit
import UserNotifications
import XCTest

typealias NotificationCallback = ([Beacon]) -> Void

class CampaignsCoordinatorMock: CampaignsCoordinator {

	var notificationCallBack: NotificationCallback?

	override func requestCampaigns(forBeacons beacons: [Beacon]) -> Promise<[Campaign]> {
		notificationCallBack?(beacons)
		return Promise<[Campaign]>.value([])
	}
}

class CampaignsCoordinatorTests: XCTestCase {

	// swiftlint:disable:next implicitly_unwrapped_optional
	private var content: CampaignContent!

	private var coordinator: CampaignsCoordinatorMock?

	override func setUp() {
		super.setUp()

		coordinator = CampaignsCoordinatorMock()
	}
/*
	func testRequestCampaignReceivedBeacons() {

		let expectation = self.expectation(description: "Widget Coordinator did not get notified")

		coordinator?.notificationCallBack = { beacons in
			XCTAssert(beacons.first?.minorDec == 59991)
			XCTAssert(beacons[1].minorDec == 77777)
			expectation.fulfill()
		}

		let beacon1 = Beacon(type: .beacon, proximity: .near, major: 8, minorDec: 59991)
		let beacon2 = Beacon(type: .beacon, proximity: .near, major: 17, minorDec: 77777)

		coordinator?.didFindBeacons(beacons: [beacon1, beacon2])

		waitForExpectations(timeout: 3)
	}*/
}
