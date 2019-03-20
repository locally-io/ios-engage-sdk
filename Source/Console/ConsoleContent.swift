//
//  ConsoleContent.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 26/02/19.
//  Copyright © 2019 Locally. All rights reserved.
//

import CoreLocation
import Foundation

enum ConsoleMessage: String {
    
    case locationUpdate = "location update"
    case geofenceRequest = "geofence impression"
    case geofenceResponse = "geofence campaign"
    case prepareScanBeacons = "initializing beacon scanner"
    case beaconDetect = "beacon detected"
    case beaconRequest = "beacon impression"
    case beaconResponse = "beacon campaign"
    case geofenceEnter = "enter geofence"
    case geofenceExit = "exit geofence"
    case interaction = "interaction"
    case inrangeRequest = "geofences in range request"
    case inrangeResponse = "geofence in range response"
}

public struct ConsoleContent {
    
    var messageResult = ""
    let location: CLLocation?
    
    init(message: ConsoleMessage, location: CLLocation) {
        
        self.location = location
        let lat = String(format: "%f", location.coordinate.latitude)
        let long = String(format: "%f", location.coordinate.longitude)
        messageResult = dateString(time: Date()) + " " + message.rawValue + "(" + lat + ", " + long + ")"
    }
    
    init(message: ConsoleMessage, beacon: Beacon) {
        self.location = nil
        messageResult = "\(dateString(time: Date())) \(message.rawValue) major: \(beacon.major), minor: \(beacon.minorDec), prox: \(beacon.proximity)"
    }
    
    init(message: ConsoleMessage) {
        self.location = nil
        messageResult = "\(dateString(time: Date())) \(message.rawValue)"
    }
    
    init(message: ConsoleMessage, forCampaign title: String) {
        self.location = nil
        messageResult = "\(dateString(time: Date())) \(message.rawValue): \(title)"
    }
    
    public func getMessage() -> String {
        return messageResult
    }
    
    public func getLocation() -> CLLocation? {
        return location
    }
    
    private func dateString(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: time)
    }
}
