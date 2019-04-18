//
//  CouponsFactory.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 07/04/19.
//  Copyright © 2019 Locally. All rights reserved.
//

import Foundation

class CouponsFactory: WidgetFactory {
    private static let xibFactory = "Coupon"
    
    private enum CouponsLayout: String {
        case couponQr = "c_below_qr"
    }
    
    static func widget(fromContent content: CampaignContent) -> WidgetViewController? {
        switch content.subLayout {
        case CouponsLayout.couponQr.rawValue:
            // swiftlint:disable:next redundant_type_annotation
            let coupons: CouponsViewController = CouponsViewController.fromNib(nibName: xibFactory)
            coupons.id = content.id
            coupons.content = content.couponsContent
            return coupons
        default:
            return nil
        }
    }
}
