//
//  Utils.swift
//  EngageSDK
//
//  Created by Imagen Rodolfo Pujol Luna on 14/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import CoreBluetooth
import Foundation
import UIKit

enum Utils {
    
    private static let centralManager = CBCentralManager()
    
    static var deviceId: String? {
        guard let uuidString = UIDevice.current.identifierForVendor?.uuidString else { return nil }
        return uuidString.replacingOccurrences(of: "-", with: "")
    }
    
    static var formatedDate: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    static var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Undefined"
    }
    
    static var isBluetoothEnabled: Bool {
        return centralManager.state == .poweredOn
    }
    
    static var wiFiAddress: WiFiAddresses {
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        var ip4 = ""
        var ip6 = ""
        
        guard getifaddrs(&ifaddr) == 0 else { return WiFiAddresses(ip4: "", ip6: "") }
        
        guard let firstAddr = ifaddr else { return WiFiAddresses(ip4: "", ip6: "") }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let name = String(cString: interface.ifa_name)
            if name == "en0" {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) {
                    ip4 = String(cString: hostname)
                }
                if addrFamily == UInt8(AF_INET6) {
                    ip6 = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        let address = WiFiAddresses(ip4: ip4, ip6: ip6)
        return address
    }
}

struct WiFiAddresses {
    let ip4: String
    let ip6: String
}
