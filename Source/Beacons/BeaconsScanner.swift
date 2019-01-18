//
//  BeaconScanner.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 24/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import KontaktSDK
import PromiseKit

enum BeaconsScannerError: Error {
	case regionCouldNotBeInitialized
}

protocol BeaconsScannerDelegate: class {
	func didFindBeacons(beacons: [Beacon])
}

class BeaconsScanner: NSObject {

	weak var delegate: BeaconsScannerDelegate?

	private var (regionStatePromise, regionStateSeal) = Promise<(region: KTKBeaconRegion, state: CLRegionState)>.pending()

	private lazy var manager = KTKBeaconManager(delegate: self)

	private lazy var beaconRegion: Promise<KTKBeaconRegion> = {

		Promise { seal in

			guard let proximityUUID = UUID(uuidString: Constants.UUID) else {
				seal.reject(BeaconsScannerError.regionCouldNotBeInitialized)
				return
			}

			let region = KTKBeaconRegion(proximityUUID: proximityUUID, identifier: Constants.regionIdentifier)
			region.notifyEntryStateOnDisplay = true

			seal.fulfill(region)
		}
	}()

	init(delegate: BeaconsScannerDelegate? = nil) {
		super.init()
		self.delegate = delegate
		Kontakt.setAPIKey(ConfigurationKeys.kontaktApiKey)
	}

	func scan() -> Promise<Void> {

		return firstly {
			beaconRegion
		}.then { region -> Promise<(region: KTKBeaconRegion, state: CLRegionState)> in
			self.requestState(forRegion: region)
		}.done { region, state in
			self.startScanning(region: region, forState: state)
		}
	}

	private func requestState(forRegion region: KTKBeaconRegion) -> Promise<(region: KTKBeaconRegion, state: CLRegionState)> {

		// Bug: When the region is created on the first time, if we try to request it's state without
		// monitoring it first, an error is raised
		manager.startMonitoring(for: region)
		manager.requestState(for: region)

		return regionStatePromise
	}

	private func startScanning(region: KTKBeaconRegion, forState state: CLRegionState) {
		switch state {
			case .inside:
				manager.startRangingBeacons(in: region)
			default:
				manager.startMonitoring(for: region)
		}
	}

	private func resetStatePromise() {
		(regionStatePromise, regionStateSeal) = Promise<(region: KTKBeaconRegion, state: CLRegionState)>.pending()
	}
}

extension BeaconsScanner: KTKBeaconManagerDelegate {

	func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
		print(error.debugDescription)
	}

	func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
		manager.requestState(for: region)
	}

	func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
		manager.startRangingBeacons(in: region)
	}

	func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
		manager.stopRangingBeacons(in: region)
	}

	func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion) {

		guard !beacons.isEmpty else { return }

		manager.stopRangingBeacons(in: region)

		let newBeacons = beacons.map { Beacon(beacon: $0) }

		delegate?.didFindBeacons(beacons: newBeacons)
	}

	func beaconManager(_ manager: KTKBeaconManager, didDetermineState state: CLRegionState, for region: KTKBeaconRegion) {

		guard state != .unknown else { return }

		regionStateSeal.fulfill((state: state, region: region))

		resetStatePromise()
	}
}
