//
//  BeaconScannerTest.swift
//  EngageSDKTests
//
//  Created by Rodolfo Pujol Luna on 29/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import KontaktSDK
import PromiseKit
import XCTest

class BeaconsScannerTests: XCTestCase {

	func testBeaconScannerWithBeaconsSucceed() {

		let expectation = self.expectation(description: "beacon array")

		let scanner = BeaconScannerMock(emptyResponse: false)

		_ = scanner.scan().done { _ in
			expectation.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
		}

		waitForExpectations(timeout: 3.0)
	}

	func testBeaconScannerWithEmptyArraySucceed() {

		let expectation = self.expectation(description: "empty beacon array")

		let scanner = BeaconScannerMock(emptyResponse: true)

		_ = scanner.scan().done { _ in
			expectation.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
		}
		
		waitForExpectations(timeout: 3.0)
	}
}

class BeaconScannerMock: BeaconsScanner {

	let emptyResponse: Bool

	init(emptyResponse: Bool) {
		self.emptyResponse = emptyResponse
	}

	override func scan(cache: Bool = true) -> Promise<Void> {

		if emptyResponse {
			delegate?.didFindBeacons(beacons: [])
		} else {
			delegate?.didFindBeacons(beacons: fillArray())
		}

		return Promise<Void>.value(())
	}

	func fillArray() -> [Beacon] {

		var beacons = [Beacon]()

		beacons.append(Beacon(type: .beacon, proximity: .touch, major: 2, minorDec: 414))
		beacons.append(Beacon(type: .beacon, proximity: .far, major: 2, minorDec: 415))
		beacons.append(Beacon(type: .beacon, proximity: .near, major: 3, minorDec: 308))

		return beacons
	}
}
