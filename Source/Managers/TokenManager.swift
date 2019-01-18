//
//  TokenManager.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 14/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

/// Store and manage the access token
enum TokenManager {

	private static let sevenDays = TimeInterval(604800)

	private enum Keys: String {
		case token, refreshToken, refreshTokenDate
	}

	static var accessToken: (String, String)? {
		didSet {
			guard let (token, refreshToken) = accessToken else { return }
			self.token = token
			self.refreshToken = refreshToken
			self.refreshTokenDate = Date()
		}
	}

	static var isTokenInvalid: Bool {
		guard let refreshTokenDate = refreshTokenDate else { return true }
		return Date().timeIntervalSince(refreshTokenDate) > sevenDays
	}

	static func invalidateToken() {
		token = nil
		refreshToken = nil
		refreshTokenDate = nil
	}

	private(set) static var token: String? {
		get {
			return UserDefaults.standard.string(forKey: Keys.token.rawValue)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Keys.token.rawValue)
		}
	}

	private(set) static var refreshToken: String? {
		get {
			return UserDefaults.standard.string(forKey: Keys.refreshToken.rawValue)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Keys.refreshToken.rawValue)
		}
	}

	private static var refreshTokenDate: Date? {
		get {
			return UserDefaults.standard.object(forKey: Keys.refreshTokenDate.rawValue) as? Date
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Keys.refreshTokenDate.rawValue)
		}
	}
}
