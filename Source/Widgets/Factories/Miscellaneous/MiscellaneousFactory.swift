//
//  MiscellaneousFactory.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 6/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

class MiscellaneousFactory: WidgetFactory {

	private static let xibFactory = "Miscellaneous"

	private enum MiscellaneousLayout: String {
		case fullScreenImage = "b_full_screen_image"
		case fullScreenVideo = "b_full_screen_video"
		case videoWithImage
	}

    static func widget(fromContent content: CampaignContent) -> WidgetViewController? {

		switch content.subLayout {

			case MiscellaneousLayout.fullScreenImage.rawValue:
				// swiftlint:disable:next redundant_type_annotation
				let miscellaneous: MiscellaneousImageViewController = MiscellaneousImageViewController.fromNib(nibName: xibFactory)
                miscellaneous.id = content.id
				miscellaneous.content = content.miscellaneousFullScreenContent
				return miscellaneous
        case MiscellaneousLayout.fullScreenVideo.rawValue:
            // swiftlint:disable:next redundant_type_annotation
            let miscellaneous: MiscellaneousImageViewController = MiscellaneousImageViewController.fromNib(nibName: xibFactory)
            miscellaneous.id = content.id
            miscellaneous.content = content.miscellaneousFullScreenContent
            return miscellaneous

			default:
				return nil
		}
	}
}
