//
//  GeofecesMonitorTests.swift
//  EngageSDKTests
//
//  Created by Rodolfo Pujol Luna on 27/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreLocation
import OHHTTPStubs
import XCTest

class GeofencesServicesTests: XCTestCase {
    /*
    func testGeofenceImpressionsSucceed() {
        
        let expectation = self.expectation(description: "Show geofence")
        
        let location = Location(longitude: -109.938047, latitude: 27.498933, altitude: 238.3782, horizontal: 8, speed: -1, vertical: 3)
		let request = GeofencesRequest(isBluetoothEnabled: true, location: location)
        
        _ = GeofencesServices.getGeofences(geofencesRequest: request)
            .done { _ in
                
                expectation.fulfill()
            }.catch { error in
                
                guard error is NetworkError else {
                    expectation.fulfill()
                    return
                }
                
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testGeofencesWithEmptyDataError() {
        
        let expectation = self.expectation(description: "No data find")
        
        let location = Location(longitude: -118.316509, latitude: 33.8806, altitude: 238.3782, horizontal: 8, speed: -1, vertical: 3)
        
        stub(condition: isMethodPOST()) { _ -> OHHTTPStubsResponse in
            
				   OHHTTPStubsResponse(jsonObject: [:],
                                       statusCode: 200,
                                       headers: ["Content-Type": "application/json"])
        }
        
		let request = GeofencesRequest(isBluetoothEnabled: true, location: location)
		_ = GeofencesServices.getGeofences(geofencesRequest: request).done { _ in
            expectation.fulfill()
            
		}.catch { error in
                guard error is NetworkError else {
                    expectation.fulfill()
                    return
                }
                
                XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 3.0, handler: nil)
    }*/
}
