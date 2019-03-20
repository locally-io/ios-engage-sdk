//
//  ColorPalette.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 21/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import UIKit

enum ColorPalette {
    static let blackOverlay = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    static let green        = UIColor(hex: "#02A65A")
}

extension UIColor {
    
    convenience init(hex: String) {
        
        let hexWithoutHashes = hex.replacingOccurrences(of: "#", with: "")
        
        let scanner = Scanner(string: hexWithoutHashes)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff
        
        self.init( red: CGFloat(red) / 0xff, green: CGFloat(green) / 0xff, blue: CGFloat(blue) / 0xff, alpha: 1)
    }
}
