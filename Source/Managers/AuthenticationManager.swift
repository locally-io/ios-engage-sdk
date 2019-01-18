//
//  AuthenticationManager.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 14/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

enum AuthenticationManagerError: String, Error {
	case deviceIdCouldNotBeFound = "Device Id Could Not Be Found"
	case accessTokenCouldNotBeFound = "Access Token Could Not Be Found"
	case refreshTokenCouldNotBeFound = "Refresh Token Could Not Be Found"
	case authenticationInvalid = "You have to login first before using this feature, please call initialize operation passing your credentials"
}

struct ConfigurationKeys {

	private init() {}

	private(set) static var guid: String?
	private(set) static var kontaktApiKey: String?
	private(set) static var aws: AWS?

	fileprivate static func initialize(guid: String, kontaktApiKey: String, aws: AWS) {
		self.guid = guid
		self.kontaktApiKey = kontaktApiKey
		self.aws = aws
	}
}

/// The entity responsible to manage user authentication on the platform
class AuthenticationManager {

	private init() {}

	static var isAuthenticated: Bool {
		return !TokenManager.isTokenInvalid
	}

	/// Authenticate an user on the platform
	///
	/// - Parameters:
	///   - username: A string that represents the username
	///   - password: A string that represents the password
	/// - Returns: A boolean Promise
	static func login(username: String, password: String) -> Promise<Void> {

		guard let deviceId = Utils.deviceId else { return Promise(error: AuthenticationManagerError.deviceIdCouldNotBeFound) }

		guard TokenManager.isTokenInvalid else {
			return Promise<Void>.init()
		}

		return Promise { seal in
			_ = AuthenticationServices.login(username: username, password: password, deviceId: deviceId).done { response in
				ConfigurationKeys.initialize(guid: response.data.appGuid, kontaktApiKey: response.data.kontaktApiKey, aws: response.data.aws)
				TokenManager.accessToken = (response.data.token, response.data.refresh)
				seal.fulfill(())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	/// Try to retrieve and return a valid access token
	///
	/// - Returns: A promise containing an access token or an error otherwise
	static func accessToken() -> Promise<String> {

		return Promise { seal in

			guard let token = TokenManager.token else {
				seal.reject(AuthenticationManagerError.accessTokenCouldNotBeFound)
				return
			}

			guard TokenManager.isTokenInvalid else {
				seal.fulfill(token)
				return
			}

			guard let refreshToken = TokenManager.refreshToken else {
				seal.reject(AuthenticationManagerError.refreshTokenCouldNotBeFound)
				return
			}

			guard let deviceId = Utils.deviceId else {
				seal.reject(AuthenticationManagerError.deviceIdCouldNotBeFound)
				return
			}

			_ = AuthenticationServices.refreshToken(refreshToken: refreshToken, deviceId: deviceId).done { response in
				TokenManager.accessToken = (response.data.token, response.data.refresh)
				seal.fulfill(response.data.token)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
