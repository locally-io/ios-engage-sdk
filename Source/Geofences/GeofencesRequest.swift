//
//  GeofencesRequest.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 27/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct GeofencesRequest {
    
    let type: ImpressionType
    let proximity: GeofencesProximity
    let age: Int
    let gender: Gender
    let isBluetoothEnabled: Bool
    let location: Location
    
    init(age: Int = 0, gender: Gender = .Male, isBluetoothEnabled: Bool, location: Location) {
        self.type = .geofence
        self.proximity = .enter
        self.isBluetoothEnabled = isBluetoothEnabled
        self.age = age
        self.gender = gender
        self.location = location
    }
}
