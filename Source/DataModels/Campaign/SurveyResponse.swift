//
//  SurveyResponse.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 21/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

struct SurveyResponse: Codable {
    
    enum SurveyQuestionType: String, Codable {
        case text, rating5, rating10, yesNo
    }
    
    struct SurveyQuestion: Codable {
        let title: String
        let type: SurveyQuestionType
        let sort: Int
        let surveyId: Int
    }
    
    let id: Int
    let title: String
    let resultEndpoint: URL
    let surveyQuestions: [SurveyQuestion]
    let defaultResultEndpoint: URL
}
