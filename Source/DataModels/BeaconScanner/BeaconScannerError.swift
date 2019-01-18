//
//  BeaconScannerError.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 31/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

enum BeaconScannerError: Error {
    case uuidCouldNotBeFound
    case locationPermissionNotProvided
}
