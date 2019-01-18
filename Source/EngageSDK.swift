//
//  EngageSDK.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 19/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

// swiftlint:disable:next identifier_name
public let Engage = EngageSDK.shared

public class EngageSDK {

	static let shared = EngageSDK()

	// MARK: - Public Properties
	public var deviceToken: Data? {
		didSet {
			NotificationManager.shared.deviceToken = deviceToken
		}
	}

	public var initialized: (() -> Void)? {
		didSet {
			guard AuthenticationManager.isAuthenticated else { return }
			initialized?()
		}
	}

	// MARK: - Private Properties
	private var beaconsMonitor: BeaconsMonitor

	private var geofencesMonitor: GeofencesMonitor

	// MARK: - Initialization
	private init() {
		beaconsMonitor = BeaconsMonitor(listener: CampaignsCoordinator())
		geofencesMonitor = GeofencesMonitor()

		NotificationCenter.observe(event: .enterOnBackground, observer: self, selector: #selector(appMovedToBackground))
	}

	// MARK: - Public Operations
	public func initialize(username: String, password: String) {
		_ = AuthenticationManager.login(username: username, password: password).done { [weak self] _ in
			self?.initialized?()
		}
	}

	public func startMonitoringBeacons() {
		beaconsMonitor.startMonitoring()
	}

	public func startMonitoringGeofences() {
		geofencesMonitor.startMonitoring()
	}

	public func stopMonitoringGeofences() {
		geofencesMonitor.stopMonitoring()
	}

	public func getHomeScreens(callback: @escaping ([Screen]) -> Void ) {
		guard let guid = ConfigurationKeys.guid else { return }
		_ = HomeServices.getScreens(guid: guid).done { response in
			callback(response.data)
		}
	}
	
	@objc
	func appMovedToBackground() {
		startMonitoringBeacons()
	}
}
