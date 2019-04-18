//
//  GeofencesServices.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 27/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

public class GeofencesServices: AuthorizedService {
	static func getGeofences(geofencesRequest: GeofencesRequest) -> Promise<GeofencesCampaign> {

        let impressions = GeofencesImpressions(bluetoothEnabled: geofencesRequest.isBluetoothEnabled,
		                                       proximity: geofencesRequest.proximity,
		                                       age: geofencesRequest.age,
		                                       gender: geofencesRequest.gender,
		                                       location: geofencesRequest.location)

		return postAuthorized(url: "\(URLS.base)/impressions/multi-geofence.json", requestData: impressions)
	}
    
    static func getGeofenceRegions(request: GeofenceRegionRequest) -> Promise<GeofenceRegion> {
        
        return getAuthorized(url: "\(URLS.base)/geofences/inRange.json?lat=\(request.lat)&lng=\(request.lng)&radius=\(request.radius)")
    }
}
