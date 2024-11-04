//
//  UserMO.swift
//  Bets4Beers
//
//  Created by iOS Dev on 04/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class UserMO: Mappable, Stringify {
    var email: String?
    var userName: String?
    var timeStamp: Int64?
    var dob: String?
    var uid: String?
    var profileImage: String?
    var password: String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case userName = "userName"
        case timeStamp = "timeStamp"
        case dob = "dob"
        case uid = "uid"
        case profileImage = "profileImage"
    }
    
    init?(with params: [String: Any]?) {
        guard let emailGet = params?[CodingKeys.email.rawValue] as? String else { return nil }
        email = emailGet
        userName = params?[CodingKeys.userName.rawValue] as? String
        timeStamp = params?[CodingKeys.timeStamp.rawValue] as? Int64
        dob = params?[CodingKeys.dob.rawValue] as? String
        uid = params?[CodingKeys.uid.rawValue] as? String
        profileImage = params?[CodingKeys.profileImage.rawValue] as? String
    }
}


class ScreenShotMO: Mappable, Stringify {
    var email: String?
    var userName: String?
    var timeStamp: Int64?
    var uid: String?
    var screenShotImage: String?
    var status: String?
    var surveyName: String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case userName = "userName"
        case timeStamp = "timeStamp"
        case uid = "uid"
        case screenShotImage = "screenShotImage"
        case status = "status"
        case surveyName = "surveyName"
    }
    
    init?(with params: [String: Any]?) {
        guard let emailGet = params?[CodingKeys.email.rawValue] as? String else { return nil }
        email = emailGet
        userName = params?[CodingKeys.userName.rawValue] as? String
        timeStamp = params?[CodingKeys.timeStamp.rawValue] as? Int64
        uid = params?[CodingKeys.uid.rawValue] as? String
        screenShotImage = params?[CodingKeys.screenShotImage.rawValue] as? String
        status = params?[CodingKeys.status.rawValue] as? String
        surveyName = params?[CodingKeys.surveyName.rawValue] as? String
    }
}
