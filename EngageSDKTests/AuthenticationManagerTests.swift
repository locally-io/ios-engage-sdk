//
//  AuthenticationManagerTests.swift
//  EngageSDKTests
//
//  Created by Eduardo Dias on 6/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import OHHTTPStubs
import XCTest

class AuthenticationManagerTests: XCTestCase {

	override func setUp() {
		super.setUp()
		TokenManager.invalidateToken()
	}

	func testTokenHasBeenSetAfterAuthentication() {

		let expectation = self.expectation(description: "Access token has not been set after authentication")

		stub(condition: isMethodPOST()) { _ -> OHHTTPStubsResponse in
			OHHTTPStubsResponse(jsonObject: ["success": true,
			                                 "data": ["refresh": "refresh_token",
			                                          "token": "token",
			                                          "sns": "sns",
			                                          "appGuid": "test_appGuid",
			                                          "kontakt_api_key": "sjdhfsjsdf897",
			                                          "aws": [
			                                          	"sns": "test_sns",
			                                          	"ios_arn": "sjkdhdkhfkzdfdz87979879",
			                                          	"identity_pool_id": "skljldf0s8d08098"
			                    ]]],
			                    statusCode: 200,
			                    headers: ["Content-Type": "application/json"])
		}

		_ = AuthenticationManager.login(username: "test", password: "test").done {
			XCTAssert(TokenManager.token == "token")
			expectation.fulfill()
		}

		waitForExpectations(timeout: 3.0)
	}

	func testAccessTokenCouldNotBeFoundIssueIsRaised() {

		let expectation = self.expectation(description: "Issue AccessTokenCouldNotBeFound was not raised")

		_ = AuthenticationManager.accessToken().catch { error in
			XCTAssert(error.localizedDescription == AuthenticationManagerError.accessTokenCouldNotBeFound.localizedDescription)
			expectation.fulfill()
		}

		waitForExpectations(timeout: 3.0)
	}
}
