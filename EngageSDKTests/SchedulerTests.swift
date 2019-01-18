//
//  SchedulerTests.swift
//  EngageSDKTests
//
//  Created by Eduardo Dias on 21/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import XCTest

class SchedulerTests: XCTestCase {

	func testFireEventIsHitOnlyCertainNumberOfTime() {

		var numOfHits = 0

		let expectation = self.expectation(description: "Interval")

		let scheduler = Scheduler.runEvery(interval: 1) { scheduler in
			numOfHits += 1
			guard numOfHits == 3 else { return }
			scheduler.stop()
			expectation.fulfill()
		}

		if scheduler.isRunning {}

		waitForExpectations(timeout: 4)
	}

	func testDelayIntervalIsRespected() {

		let initialTime = Date()

		let expectation = self.expectation(description: "Delay interval is not respected")

		let scheduler = Scheduler.runOnce(delay: 2) { _ in
			let timeElapsed = Int(Date().timeIntervalSince(initialTime))
			guard timeElapsed == 2 else { return }
			expectation.fulfill()
		}

		if scheduler.isRunning {}

		waitForExpectations(timeout: 3)
	}

	func testRunOnceOperationIsRespected() {

		let expectation = self.expectation(description: "Delay interval is not respected")

		let scheduler = Scheduler.runOnce(delay: 2) { _ in
			expectation.fulfill()
		}

		if scheduler.isRunning {}

		waitForExpectations(timeout: 3)
	}
}
