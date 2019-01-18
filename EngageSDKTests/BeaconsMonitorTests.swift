//
//  BeaconsMonitorTests.swift
//  EngageSDKTests
//
//  Created by Imagen DIDCOM on 14/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import PromiseKit
import XCTest

//class BeaconsMonitorTest: XCTestCase {
//    
//    func testBeaconMonitorWithDefaultIntervalSucceed() {
//        
//        let expectation = self.expectation(description: "beacon monitor")
//        
//        let delegate = BeaconsMonitorDelegateMock()
//        let monitor = BeaconsMonitorMock(delegate: delegate, beaconIdentifier: "test monitor")
//        
//        delegate.didUpdateBeaconsMonitorClosure = { beacons in
//            expectation.fulfill()
//        }
//        
//        monitor.startMonitor()
//        
//        waitForExpectations(timeout: 10.0, handler: nil)
//    }
//    
//    func testBeaconMonitorWithCustomIntervalSucceed() {
//        
//        let expectation = self.expectation(description: "beacon monitor")
//        let interval = TimeInterval(1)
//        
//        let delegate = BeaconsMonitorDelegateMock()
//        let monitor = BeaconsMonitorMock(delegate: delegate, beaconIdentifier: "test monitor", interval: interval)
//        
//        delegate.didUpdateBeaconsMonitorClosure = { beacons in
//            expectation.fulfill()
//        }
//        
//        monitor.startMonitor()
//        
//        waitForExpectations(timeout: interval * 5, handler: nil)
//    }
//}
//
//class BeaconsMonitorMock: BeaconsMonitor {
//    override func startMonitor() {
//        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (_) in
//            let scanner = BeaconScannerMock(identifier: self.identifier, emptyResponse: false)
//            scanner.scan().done { beacons in
//                self.delegate?.didUpdateBeaconsMonitor(self, beacons: beacons)
//                }.catch({ _ in
//                    
//                })
//        }
//    }
//}
//
//class BeaconsMonitorDelegateMock: BeaconsMonitorDelegate {
//    
//    var didUpdateBeaconsMonitorClosure: (([Beacon]) -> Void)?
//    var reads = 0
//    
//    func didUpdateBeaconsMonitor(_ manager: BeaconsMonitor, beacons: [Beacon]) {
//        reads += 1
//        print("Date: \(Date())")
//        for beacon in beacons {
//            print("major: \(beacon.major), minor: \(beacon.minorDec), proximity: \(beacon.proximity)")
//        }
//        print("")
//        
//        guard reads == 3, let closure = didUpdateBeaconsMonitorClosure else {
//            return
//        }
//        closure(beacons)
//    }
