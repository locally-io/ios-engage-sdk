//
//  WidgetsPresenterTests.swift
//  EngageSDKTests
//
//  Created by Eduardo Dias on 17/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import XCTest

class WidgetsPresenterTests: XCTestCase {
/*
	func testMiscellaneousImageIsPresented() {

		let expectation = self.expectation(description: "Miscellaneous Image failed to present with campaign content")
        
        let campaignContent = CampaignContent(id: 2,
                                              impressionId: 1,
		                                      name: "",
		                                      description: "",
		                                      notificationMessage: "",
		                                      layout: "",
		                                      subLayout: "b_full_screen_image",
		                                      checkVideo: "",
		                                      checkImage: "",
		                                      headerTitle: "",
		                                      videoDescriptionText: "",
		                                      productName: "",
		                                      productDescription: "",
		                                      productPrice: nil,
		                                      interactionMethod: "",
                                              qrCodeImageUrl: "",
		                                      attributes: .init(message: "",
                                                                pushMessage: "",
                                                                link: "",
																submit: "",
																backgroundGradientTop: "",
																backgroundGradientBottom: "",
																textColor: ""),
		                                      survey: nil,
		                                      campaignContentActions: [],
		                                      campaignContentButtons: [],
		                                      mediaVideo: nil,
		                                      mediaImage: nil)

		WidgetsPresenter.shared.presentWidget(withContent: campaignContent) { presented in

			guard presented else {
				XCTFail("Miscellaneous Image fail to present itself")
				return
			}

			if UIApplication.shared.keyWindow?.topMostViewController?.className == "MiscellaneousImageViewController" {
				expectation.fulfill()
			}
		}

		waitForExpectations(timeout: 30)
	}

	func testMiscellaneousImageIsNotPresentedWhenSubLayoutIsIncorrect() {

		let expectation = self.expectation(description: "Miscellaneous Image is presented even with incorrect sub layout")

        let campaignContent = CampaignContent(id: 2,
                                              impressionId: 1,
                                              name: "",
                                              description: "",
                                              notificationMessage: "",
                                              layout: "",
                                              subLayout: "b_full_screen_image",
                                              checkVideo: "",
                                              checkImage: "",
                                              headerTitle: "",
                                              videoDescriptionText: "",
                                              productName: "",
                                              productDescription: "",
                                              productPrice: nil,
                                              interactionMethod: "",
                                              qrCodeImageUrl: "",
                                              attributes: .init(message: "",
                                                                pushMessage: "",
                                                                link: "",
                                                                submit: "",
                                                                backgroundGradientTop: "",
                                                                backgroundGradientBottom: "",
                                                                textColor: ""),
                                              survey: nil,
                                              campaignContentActions: [],
                                              campaignContentButtons: [],
                                              mediaVideo: nil,
                                              mediaImage: nil)

		WidgetsPresenter.shared.presentWidget(withContent: campaignContent) { presented in

			guard presented else {
				expectation.fulfill()
				return
			}

			XCTFail("Miscellaneous Image should not be presented with incorrect sub layout")
		}

		waitForExpectations(timeout: 3)
	}*/
}
