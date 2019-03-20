//
//  GeofenceRegion.swift
//  Alamofire
//
//  Created by Rodolfo Pujol Luna on 28/02/19.
//

import Foundation

public struct Circle: Decodable {
    let lat: Double
    let lng: Double
    let radius: Double
}

public enum Coverage: String, Decodable {
    case radius, polygon
}

public struct Region: Decodable {
    let campaignId: Int?
    let coverageType: Coverage?
    let center: Circle?
    let points: [[Double]]?
}

public struct GeofenceRegion: Decodable {
    
    let success: Bool
    let data: [Region]?
    let totalCount: Int?
}