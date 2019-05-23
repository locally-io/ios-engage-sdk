//
//  EngageSDK.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 19/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreLocation
import Foundation
import PromiseKit

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
            geofencesMonitor.clearCache()
			initialized?()
		}
	}

	// MARK: - Private Properties
	private var beaconsMonitor: BeaconsMonitor
    private var geofencesMonitor: GeofencesMonitor
    private var geofencesRegionMonitor: GeofencesRegionMonitor

	public var presenterDelegate: WidgetsPresenterDelegate? {
		didSet {
			WidgetsPresenter.shared.delegate = presenterDelegate
		}
	}
    
    public weak var consoleDelegate: ConsoleDelegate? {
        didSet {
            ConsolePresenter.shared.delegate = consoleDelegate
        }
    }
    
	// MARK: - Initialization
	private init() {
		beaconsMonitor = BeaconsMonitor(listener: CampaignsCoordinator())
		geofencesMonitor = GeofencesMonitor()
        geofencesRegionMonitor = GeofencesRegionMonitor()
		NotificationCenter.observe(event: .enterOnBackground, observer: self, selector: #selector(appMovedToBackground))
	}

	// MARK: - Public Operations
    public func initialize(username: String, password: String) -> Promise<Bool> {
        let isLogged = AuthenticationManager.login(username: username, password: password)
        self.initialized?()
        return isLogged
    }
    
    public var isAuthorizedAlwaysLocation: Bool {
        return LocationManager.checkAlwaysPermissions()
    }
    
    public var monitoringStatus: CLAuthorizationStatus {
        return LocationManager.checkStatusPermission()
    }
    
    public var isAuthorizedAlwaysOrNotDeterminedLoc: Bool {
        return LocationManager.checkAlwaysOrNotDeterminedPermissions()
    }
    
    public func isValidToken() -> Bool {
        return !TokenManager.isTokenInvalid
    }
    
    public func logout() {
        geofencesMonitor.stopMonitoring()
        geofencesMonitor = GeofencesMonitor()
        beaconsMonitor.stopMonitoring()
        TokenManager.invalidateToken()
        UIApplication.shared.unregisterForRemoteNotifications()
    }

	public func startMonitoringBeacons(cache: Bool = false) -> Promise<Void> {
		return beaconsMonitor.startMonitoring(cache: cache)
	}
    
    public func stopMonitoringBeacons() {
        beaconsMonitor.stopMonitoring()
    }

	public func startMonitoringGeofences() -> Promise<Void> {
        LocationManager.setRegionDelegate(delegate: self)
        return geofencesRegionMonitor.startMonitoring()
	}

	public func stopMonitoringGeofences() {
        geofencesMonitor.stopMonitoring()
        geofencesMonitor = GeofencesMonitor()
	}

	public func getHomeScreens(callback: @escaping ([Screen]) -> Void ) {
		guard let guid = ConfigurationKeys.guid else { return }
		_ = HomeServices.getScreens(guid: guid).done { response in
			callback(response.data)
		}
	}
	
	@objc
	func appMovedToBackground() {
		//startMonitoringBeacons()
	}
}

extension EngageSDK: GeofencesRegionMonitorDelegate {
    func didChangeStatus(isInRange: Bool) {
        
        if isInRange {
            geofencesMonitor.startMonitoring()
        } else {
            geofencesMonitor.stopMonitoring()
            geofencesMonitor = GeofencesMonitor()
        }
    }
}
