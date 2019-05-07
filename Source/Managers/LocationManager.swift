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
		let status =  authorizationHandler.permissionPromise
        return status
	}
    
    static func checkAlwaysOrNotDeterminedPermissions() -> Bool {
        let authorizationStatus = AuthorizationHandler.authorizationStatus()
        guard authorizationStatus != .authorizedAlways, authorizationStatus != .notDetermined else { return true }
        DispatchQueue.main.async {
            showAlert()
        }
        return false
    }
    
    static func checkAlwaysPermissions() -> Bool {
        let authorizationStatus = AuthorizationHandler.authorizationStatus()
        guard authorizationStatus != .authorizedAlways else { return true }
        DispatchQueue.main.async {
            showAlert()
        }
        return false
    }
    
    private static func showAlert() {
        let titleAlert = "\"Locally Engage\" requires the use of Always Allow Location to monitor Beacons and Geofences"
        let messageAlert = "Please Enable in Settings."
        let alertController = UIAlertController(title: titleAlert,
                                                message: messageAlert, preferredStyle: UIAlertController.Style.alert)
        
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        let okAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        guard let viewController = UIApplication.topViewController() else { return }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func checkStatusPermission() -> CLAuthorizationStatus {
        let authorizationStatus = AuthorizationHandler.authorizationStatus()
        return authorizationStatus
    }
    
    static func setRegionDelegate(delegate: GeofencesRegionMonitorDelegate) {
        authorizationHandler.regionDelegate = delegate
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
			guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
            //authorizationHandler.startMonitoringSignificantLocationChanges()
            authorizationHandler.requestLocation()
            authorizationHandler.startUpdatingLocation()
		}
	}
    
    static func startMonitoring(forRegion region: CLCircularRegion) {
        
        _ = requestLocationPermission().done { status in
            guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
            
            authorizationHandler.startMonitoringGeofence(forRegion: region)
        }
    }

	static func stopMonitoring() {
		//authorizationHandler.stopMonitoringSignificantLocationChanges()
        authorizationHandler.stopUpdatingLocation()
	}
}

private class AuthorizationHandler: CLLocationManager, CLLocationManagerDelegate {

	var locationDelegate: LocationManagerDelegate? {
		didSet {
			lastLocationUpdate = nil
		}
	}
    
    class Geofence {
        let identifier: String
        var isInRange: Bool
        
        init(identifier: String, isInRange: Bool) {
            self.identifier = identifier
            self.isInRange = isInRange
        }
    }
    
    private var geofences = [Geofence]()
    
    weak var regionDelegate: GeofencesRegionMonitorDelegate?

	private let locationChangeThreshold = 1.5

	private var lastLocationUpdate: CLLocation?

	fileprivate var (permissionPromise, permissionSeal) = Promise<CLAuthorizationStatus>.pending()

	fileprivate var (locationPromise, locationSeal) = Promise<CLLocation>.pending()

	fileprivate var isMonitoringAuthorized: Bool {
		let authorizationStatus = AuthorizationHandler.authorizationStatus()
		return authorizationStatus == .authorizedAlways// || authorizationStatus == .authorizedWhenInUse
	}

	override init() {

		super.init()

		distanceFilter = kCLLocationAccuracyBest
		allowsBackgroundLocationUpdates = true
		pausesLocationUpdatesAutomatically = false
		delegate = self
	}
    
    func startMonitoringGeofence(forRegion region: CLCircularRegion) {
        
        let geofence = Geofence(identifier: region.identifier, isInRange: false)
        
        if !geofences.contains { actualGeofence -> Bool in
            actualGeofence.identifier == region.identifier
        } {
            geofences.append(geofence)
        }
        
        if getMonitoringRegion(withIdentifier: region.identifier) == nil {
            startMonitoring(for: region)
        }
        requestState(for: region)
    }
    
    func getMonitoringRegion(withIdentifier identifier: String) -> CLRegion? {
        
        let region = monitoredRegions.first { $0.identifier == identifier }
        
        return region
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
            ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .locationUpdate, location: lastLocation))
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
				permissionSeal.fulfill(status)//permissionSeal.reject(LocationManagerError.didNotAuthorizedLocation)
		}
		
		(permissionPromise, permissionSeal) = Promise<CLAuthorizationStatus>.pending()
	}
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let location = manager.location else { return }
        
        ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .geofenceEnter, location: location))
        regionDelegate?.didChangeStatus(isInRange: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let location = manager.location else { return }
        
        ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .geofenceExit, location: location))
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        guard let geofence = geofences.first(where: { $0.identifier == region.identifier }) else { return }
        
        switch state {
        case .inside:
            geofence.isInRange = true
        case .outside:
            geofence.isInRange = false
        case .unknown:
            print("unknow")
        }
        checkInRanges()
    }
    
    private func checkInRanges() {
        
        geofences.forEach {
            
            guard let region = getMonitoringRegion(withIdentifier: $0.identifier) else { return }
            
            if !$0.isInRange {
                stopMonitoring(for: region)
            } else {
                startMonitoring(for: region)
            }
        }
        
        let filter = geofences.filter { $0.isInRange }
        regionDelegate?.didChangeStatus(isInRange: !filter.isEmpty)
    }
}
