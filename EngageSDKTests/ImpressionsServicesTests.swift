//
//  ImpressionsServicesTest.swift
//  EngageSDKTests
//
//  Created by Rodolfo Pujol Luna on 17/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreLocation
import OHHTTPStubs
import XCTest

class ImpressionsServicesTests: XCTestCase {
/*
	func testBeaconImpressionsSucceed() {

		let expectation = self.expectation(description: "Show impressions")

		let location = Location(longitude: -118.316509, latitude: 33.8806, altitude: 238.3782, horizontal: 8, speed: -1, vertical: 3)
		let beacon = Beacon(type: .beacon, proximity: .near, major: 2, minorDec: 414)

		let request = CampaignRequest(isBluetoothEnabled: true, location: location, beacon: beacon)

		_ = CampaignServices.getCampaign(campaignRequest: request)
			.done { _ in

				expectation.fulfill()
			}.catch { error in

				guard error is NetworkError else {
					expectation.fulfill()
					return
				}

				XCTFail(error.localizedDescription)
			}

		waitForExpectations(timeout: 10.0)
	}

	func testBeaconImpressionsWithEmptyDataError() {

		let expectation = self.expectation(description: "Impressions fails with empty data")
		
		let location = Location(longitude: -118.316509, latitude: 33.8806, altitude: 238.3782, horizontal: 8, speed: -1, vertical: 3)
		let beacon = Beacon(type: .beacon, proximity: .near, major: 2, minorDec: 414)

		stub(condition: isMethodPOST()) { _ -> OHHTTPStubsResponse in
			 	   OHHTTPStubsResponse(jsonObject: [:],
			                           statusCode: 200,
			                           headers: ["Content-Type": "application/json"])
		}

		let request = CampaignRequest(isBluetoothEnabled: true, location: location, beacon: beacon)
		_ = CampaignServices.getCampaign(campaignRequest: request).done { _ in

			expectation.fulfill()

		}.catch { error in

			guard error is NetworkError else {
				expectation.fulfill()
				return
			}

			XCTFail(error.localizedDescription)
		}
		waitForExpectations(timeout: 3.0)
	}*/
}
