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
	static func getGeofences(geofencesRequest: GeofencesRequest) -> Promise<Campaign> {

		let impressions = GeofencesImpressions(bluetoothEnabled: geofencesRequest.isBluetoothEnabled,
		                                       proximity: geofencesRequest.proximity,
		                                       age: geofencesRequest.age,
		                                       gender: geofencesRequest.gender,
		                                       location: geofencesRequest.location)

		return postAuthorized(url: "\(URLS.base)/impressions/geofence.json", requestData: impressions)
	}
}
