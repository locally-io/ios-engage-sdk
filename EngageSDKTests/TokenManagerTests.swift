//
//  TokenManagerTests.swift
//  EngageSDKTests
//
//  Created by Eduardo Dias on 29/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import XCTest

class TokenManagerTests: XCTestCase {

	override func setUp() {
		super.setUp()
		TokenManager.accessToken = ("test_token", "refresh_token")
	}

    func testTokenIsSetSucessfully() {
		XCTAssert(TokenManager.token == "test_token")
    }

	func testTokenIsValidAfterSet() {
		XCTAssertFalse(TokenManager.isTokenInvalid)
	}

	func testRefreshTokenIsSetSucessfully() {
		XCTAssert(TokenManager.refreshToken == "refresh_token")
	}

	func testInvalidateTokenSetRefreshTokenToNil() {
		TokenManager.invalidateToken()
		XCTAssert(TokenManager.refreshToken == nil)
	}

	func testInvalidateTokenSetTokenToNil() {
		TokenManager.invalidateToken()
		XCTAssert(TokenManager.token == nil)
	}
	func testInvalidateTokenSetTokenToInvalid() {
		TokenManager.invalidateToken()
		XCTAssert(TokenManager.isTokenInvalid == true)
	}
}
