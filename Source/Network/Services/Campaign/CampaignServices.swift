//
//  CampaignServices.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 14/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

public class CampaignServices: AuthorizedService {

	static func getCampaign(campaignRequest: CampaignRequest) -> Promise<Campaign> {

		let impressions = BeaconImpressions(bluetoothEnabled: campaignRequest.isBluetoothEnabled,
		                                   type: campaignRequest.beacon.type,
		                                   proximity: campaignRequest.beacon.proximity,
		                                   major: campaignRequest.beacon.major,
		                                   minor: campaignRequest.beacon.minorDec,
		                                   age: campaignRequest.age,
		                                   gender: campaignRequest.gender,
		                                   location: campaignRequest.location)

		return postAuthorized(url: "\(URLS.base)/impressions/beacon.json", requestData: impressions)
	}
}
