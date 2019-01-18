//
//  LocationManager.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 19/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

import CoreLocation
import PromiseKit

enum LocationManagerError: Error {
	case didNotAuthorizedLocation
	case didNotChangeAuthorizationStatus
	case notValidAuthorizationStatus
	case locationCouldNotBeUpdated
}

protocol LocationManagerDelegate: class {
	func didChangeLocation(location: CLLocation)
}

class LocationManager: NSObject {

	private static var authorizationHandler = AuthorizationHandler()

	static func requestLocationPermission() -> Promise<CLAuthorizationStatus> {

		guard !authorizationHandler.isMonitoringAuthorized else {
			return Promise.value(AuthorizationHandler.authorizationStatus())
		}

		authorizationHandler.requestAlwaysAuthorization()
		return authorizationHandler.permissionPromise
	}

	static var currentLocation: Promise<CLLocation> {

		return firstly {
			requestLocationPermission()
		}.then { _ -> Promise<CLLocation> in
			authorizationHandler.startUpdatingLocation()
			return authorizationHandler.locationPromise
		}
	}

	static func startMonitoring(delegate: LocationManagerDelegate) {
		authorizationHandler.locationDelegate = delegate
		_ = requestLocationPermission().done { status in
			guard status == .authorizedAlways else { return }
			authorizationHandler.startMonitoringSignificantLocationChanges()
		}
	}

	static func stopMonitoring() {
		authorizationHandler.stopMonitoringSignificantLocationChanges()
	}
}

private class AuthorizationHandler: CLLocationManager, CLLocationManagerDelegate {

	var locationDelegate: LocationManagerDelegate? {
		didSet {
			lastLocationUpdate = nil
		}
	}

	private let locationChangeThreshold = 100.0

	private var lastLocationUpdate: CLLocation?

	fileprivate var (permissionPromise, permissionSeal) = Promise<CLAuthorizationStatus>.pending()

	fileprivate var (locationPromise, locationSeal) = Promise<CLLocation>.pending()

	fileprivate var isMonitoringAuthorized: Bool {
		let authorizationStatus = AuthorizationHandler.authorizationStatus()
		return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
	}

	override init() {

		super.init()

		distanceFilter = kCLLocationAccuracyBest
		allowsBackgroundLocationUpdates = true
		pausesLocationUpdatesAutomatically = false
		delegate = self
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		manager.stopUpdatingLocation()

		guard let lastLocation = locations.last else {
			locationSeal.reject(LocationManagerError.locationCouldNotBeUpdated)
			return
		}

		locationSeal.fulfill(lastLocation)

		(locationPromise, locationSeal) = Promise<CLLocation>.pending()

		guard let lastLocationUpdate = lastLocationUpdate else {
			self.lastLocationUpdate = lastLocation
			locationDelegate?.didChangeLocation(location: lastLocation)
			return
		}

		if lastLocationUpdate.distance(from: lastLocation) > locationChangeThreshold {
			locationDelegate?.didChangeLocation(location: lastLocation)
		}

		self.lastLocationUpdate = lastLocation
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		permissionSeal.reject(error)
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

		switch status {
			case .authorizedWhenInUse, .authorizedAlways:
				permissionSeal.fulfill(status)
			case .notDetermined:
				return
			default:
				permissionSeal.reject(LocationManagerError.didNotAuthorizedLocation)
		}
		
		(permissionPromise, permissionSeal) = Promise<CLAuthorizationStatus>.pending()
	}
}
