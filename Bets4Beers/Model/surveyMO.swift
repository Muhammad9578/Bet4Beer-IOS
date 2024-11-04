//
//  surveyMO.swift
//  Bets4Beers
//
//  Created by iOS Dev on 05/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class SurveyMO: Mappable, Stringify {
    var surveyName: String?
    var qrCode: String?
    var timeStamp: Int64?
    var surveyId: String?
    var surveyCode: String?
    var orderNo: Int?
    var quantity: Int?
    var redemmedQuantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case surveyName = "surveyName"
        case qrCode = "qrCode"
        case timeStamp = "timeStamp"
        case surveyCode = "surveyCode"
    }
    
    init?(with params: [String: Any]?) {
        surveyName = params?[CodingKeys.surveyName.rawValue] as? String
        timeStamp = params?[CodingKeys.timeStamp.rawValue] as? Int64
        qrCode = params?[CodingKeys.qrCode.rawValue] as? String
        surveyCode = params?[CodingKeys.surveyCode.rawValue] as? String
    }
}
