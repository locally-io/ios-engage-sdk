//
//  BeaconsMonitor.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 12/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

protocol BeaconsListener {
	func clearCache()
	func didFindBeacons(beacons: [Beacon])
}

class BeaconsMonitor {

	private lazy var scanner = BeaconsScanner(delegate: self)

	private var listenersSet: Set<AnyHashable> = []

	private var listeners: [BeaconsListener] {
		return listenersSet.compactMap { $0 as? BeaconsListener }
	}

	init<Listener>(listener: Listener) where Listener: BeaconsListener, Listener: Hashable {
		addListener(listener: listener)
	}

	func addListener<Listener>(listener: Listener) where Listener: BeaconsListener, Listener: Hashable {
		_ = listenersSet.insert(listener)
	}

	func startMonitoring(cache: Bool = true) -> Promise<Void> {

        if !cache { listeners.forEach { $0.clearCache() } }

		let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

		return firstly {
			LocationManager.requestLocationPermission()
		}.then { _ in
			NotificationManager.shared.requestNotificationPermissions()
		}.then(on: backgroundQueue) { _ in
			self.scanner.scan(cache: cache)
		}
	}
    
    func stopMonitoring() {
        LocationManager.stopMonitoring()
        self.scanner.stopScanning()
    }

	deinit {
		listenersSet.removeAll()
	}
}

extension BeaconsMonitor: BeaconsScannerDelegate {

	func didFindBeacons(beacons: [Beacon]) {
		self.listeners.forEach { $0.didFindBeacons(beacons: beacons) }
	}
}
