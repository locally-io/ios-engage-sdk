//
//  AuthenticationServicesTest.swift
//  EngageSDKTests
//
//  Created by Eduardo Dias on 11/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import OHHTTPStubs
import XCTest

class AuthenticationServicesTests: XCTestCase {

	private let data: [AnyHashable: Any] = ["data": ["refresh": "RDY4ZGVhYjQyNmM2MDc3MDgxMjc4ZGJjMDhmYjRiUmM3ZGQ3ONWZjODI4Mjg1YWQzN2UzMzgw",
	                                                 "token": "RDY4ZGVhYjQyNmM2MDc3MDgxMjc4ZGJjMDhmYjRiUmM3ZGQ3ONWZjODI4Mjg1YWQzN2UzMzgw",
	                                                 "appGuid": "test_appGuid",
	                                                 "kontakt_api_key": "sjdhfsjsdf897",
	                                                 "aws": [
	                                                 	"sns": "test_sns",
	                                                 	"ios_arn": "sjkdhdkhfkzdfdz87979879",
	                                                 	"identity_pool_id": "skljldf0s8d08098"
													  ]]
											]
/*
	func testLoginSucceed() {

		let expectation = self.expectation(description: "Authentication serializes with success")

		stub(condition: isMethodPOST()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: self.data, statusCode: 200, headers: ["Content-Type": "application/json"])
		}

		_ = AuthenticationServices.login(username: "", password: "", deviceId: "").done { _ in

			expectation.fulfill()

		}.catch { error in

			XCTFail(error.localizedDescription)
		}

		waitForExpectations(timeout: 3.0)
	}

	func testLoginFailsWithNetworkError() {

		let expectation = self.expectation(description: "Authentication fails with NetworkError")

		stub(condition: isMethodPOST()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: ["data": ["code": 422,
			                                          "url": "appslogin.json",
			                                          "message": "2 validation errors occurred",
			                                          "errorCount": 2,
			                                          "errors": [
			                                          	"username": [
			                                          		"_empty": "This field cannot be left empty"
			                                          	],
			                                          	"password": [
			                                          		"_empty": "This field cannot be left empty"
			                                          	]
			                                          ],
			                                          "exception": [
			                                          	"class": "App\\Error\\Exception\\ValidationException",
			                                          	"code": 422,
			                                          	"message": "2 validation errors occurred"
			]]],
			                    statusCode: 401,
			                    headers: ["Content-Type": "application/json"])
		}

		_ = AuthenticationServices.login(username: "", password: "", deviceId: "").done { _ in

			expectation.fulfill()

		}.catch { error in

			guard error is NetworkError else {
				XCTFail(error.localizedDescription)
				return
			}

			expectation.fulfill()
		}

		waitForExpectations(timeout: 3.0)
	}

	func testSNSKeyIsSerializedWithSuccess() {

		let expectation = self.expectation(description: "Authentication serializes with success")

		stub(condition: isMethodPOST()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: self.data, statusCode: 200, headers: ["Content-Type": "application/json"])
		}

		_ = AuthenticationServices.login(username: "", password: "", deviceId: "").done { result in

            guard let aws = result.data.aws else { return }
			XCTAssert(aws.sns == "test_sns")
			expectation.fulfill()

		}.catch { error in

			XCTFail(error.localizedDescription)
		}

		waitForExpectations(timeout: 3.0)
	}

	func testGUIDKeyIsSerializedWithSuccess() {

		let expectation = self.expectation(description: "Authentication serializes with success")

		stub(condition: isMethodPOST()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: self.data, statusCode: 200, headers: ["Content-Type": "application/json"])
		}

		_ = AuthenticationServices.login(username: "", password: "", deviceId: "").done { result in

			XCTAssert(result.data.appGuid == "test_appGuid")

			expectation.fulfill()

		}.catch { error in

			XCTFail(error.localizedDescription)
		}

		waitForExpectations(timeout: 3.0)
	}*/
}
