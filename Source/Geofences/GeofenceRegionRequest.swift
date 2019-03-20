//
//  GeofenceRegionRequest.swift
//  Alamofire
//
//  Created by Rodolfo Pujol Luna on 28/02/19.
//

import Foundation

struct GeofenceRegionRequest: Encodable {
    let lat: Double
    let lng: Double
    let radius: Double
}
