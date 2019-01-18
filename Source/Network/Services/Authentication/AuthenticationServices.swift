//
//  AuthenticationServices.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 10/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

class AuthenticationServices: NetworkService {

	/// Executes a network call and authenticate an user to the platform if passed credentials match
	///
	/// - Parameters:
	///   - username: A string representing the username
	///   - password: A string representing the user password
	///   - deviceId: A string representing the unique identifier of a certain device
	/// - Returns: A LoginResponse data containing an access token that will be used to authorize consecutive network calls
	static func login(username: String, password: String, deviceId: String) -> Promise<LoginResponse> {
		let loginRequest = LoginRequest(username: username, password: password, deviceId: deviceId)
		return POST(url: "\(URLS.base)/apps/login.json", requestData: loginRequest)
	}

	/// Executes a network call to refresh the access token
	///
	/// - Parameters:
	///   - refreshToken: A string representing a refresh token
	///   - deviceId: A string representing the unique identifier of a certain device
	/// - Returns: A LoginResponse data containing an access token that will be used to authorize consecutive network calls
	static func refreshToken(refreshToken: String, deviceId: String) -> Promise<LoginResponse> {
		let refreshTokenRequest = RefreshTokenRequest(refresh: refreshToken, deviceId: deviceId)
		return POST(url: "\(URLS.base)/apps/refresh.json", requestData: refreshTokenRequest)
	}
}
