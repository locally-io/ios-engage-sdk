//
//  HomeServicesTests.swift
//  EngageSDKTests
//
//  Created by Eduardo Dias on 18/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import OHHTTPStubs
import UIKit
import XCTest

class HomeServicesTests: XCTestCase {
/*
	func testHomePerfomsWithSuccess() {

		let expectation = self.expectation(description: "Home Services was perfomed with success")

		stub(condition: isMethodGET()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: [
				"data": [
					[
						"image": "image-link",
						"title": "This is the first slide",
						"content": "This is some example content returned from the screens",
						"link": "https://www.google.com",
						"screenOrder": "7"
					],
					[
						"image": "image-link",
						"title": "This is the first slide",
						"content": "This is some example content returned from the screens",
						"link": "https://www.google.com",
						"screenOrder": "7"
					]
				]
			],
			                    statusCode: 200,
			                    headers: ["Content-Type": "application/json"])
		}

		_ = HomeServices.getScreens(guid: "234234").done { response in
			XCTAssert(response.data.count == 2)
			expectation.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
		}

		waitForExpectations(timeout: 3.0)
	}

	func testHomePerfomsWithKeyNotFound() {

		let expectation = self.expectation(description: "Home Services was perfomed with key not found error")

		stub(condition: isMethodGET()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: [
				"data": [
					[
						"image": "image-link",
						"title": "This is the first slide",
						"content": "This is some example content returned from the screens",
						"screenOrder": "7"
					]
				]
			],
			                    statusCode: 200,
			                    headers: ["Content-Type": "application/json"])
		}

		_ = HomeServices.getScreens(guid: "234234").done { _ in

		}.catch { error in

			guard let decodingError = error as? DecodingError else {
				XCTFail("Error is not DecodingError")
				return
			}

			switch decodingError {
				case let .keyNotFound(key, _):
					XCTAssert(key.stringValue == "link")
					expectation.fulfill()
				default:
					XCTFail("decodingError is not keyNotFound")
			}
		}

		waitForExpectations(timeout: 3.0)
	}

	func testHomePerfomsWithTypeMismatch() {

		let expectation = self.expectation(description: "Home Services was perfomed with type mismatch error")

		stub(condition: isMethodGET()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: [
				"data": [
					[
						"image": 90,
						"title": "This is the first slide",
						"content": "This is some example content returned from the screens",
						"link": "https://www.google.com",
						"screenOrder": "7"
					]
				]
			],
			                    statusCode: 200,
			                    headers: ["Content-Type": "application/json"])
		}

		_ = HomeServices.getScreens(guid: "234234").done { _ in

		}.catch { error in

			guard let decodingError = error as? DecodingError else {
				XCTFail("Error is not DecodingError")
				return
			}

			switch decodingError {
				case let .typeMismatch(type, context):
					XCTAssert(type == String.self)
					XCTAssert(context.debugDescription == "Expected to decode String but found a number instead.")
					expectation.fulfill()
				default:
					XCTFail("decodingError is not type mismatch")
			}
		}

		waitForExpectations(timeout: 3.0)
	}*/
}
