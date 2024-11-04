//
//  VocherMod.swift
//  Bets4Beers
//
//  Created by Murteza on 02/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
// post data Response
struct  postVocherModel : Codable {
var category : String?
var type : String?
var discount : Discount?
var start_date : String?
var expiration_date : String?
var redemption : Redemption?
var code_config : Code_config?
var metadata : Metadata?

enum CodingKeys: String, CodingKey {

    case category = "category"
    case type = "type"
    case discount = "discount"
    case start_date = "start_date"
    case expiration_date = "expiration_date"
    case redemption = "redemption"
    case code_config = "code_config"
    case metadata = "metadata"
}
    var asDictionary : [String:Any] {
         let mirror = Mirror(reflecting: self)
         let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String!,value:Any) -> (String,Any)? in
             guard label != nil else { return nil }
             return (label!,value)
         }).compactMap{ $0 })
         return dict
     }
}


struct Code_config : Codable {
var pattern : String?

enum CodingKeys: String, CodingKey {

    case pattern = "pattern"
}
    var asDictionary : [String:Any] {
         let mirror = Mirror(reflecting: self)
         let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String!,value:Any) -> (String,Any)? in
             guard label != nil else { return nil }
             return (label!,value)
         }).compactMap{ $0 })
         return dict
     }
}
struct Discount : Codable {
var percent_off : Int?
var type : String?

enum CodingKeys: String, CodingKey {

    case percent_off = "percent_off"
    case type = "type"
}
    var asDictionary : [String:Any] {
         let mirror = Mirror(reflecting: self)
         let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String!,value:Any) -> (String,Any)? in
             guard label != nil else { return nil }
             return (label!,value)
         }).compactMap{ $0 })
         return dict
     }
}
struct Metadata : Codable {
var test : Bool?
var locale : String?

enum CodingKeys: String, CodingKey {

    case test = "test"
    case locale = "locale"
}
    var asDictionary : [String:Any] {
         let mirror = Mirror(reflecting: self)
         let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String!,value:Any) -> (String,Any)? in
             guard label != nil else { return nil }
             return (label!,value)
         }).compactMap{ $0 })
         return dict
     }
}
struct Redemption : Codable {
var quantity : Int?

enum CodingKeys: String, CodingKey {

    case quantity = "quantity"
}
    var asDictionary : [String:Any] {
         let mirror = Mirror(reflecting: self)
         let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String!,value:Any) -> (String,Any)? in
             guard label != nil else { return nil }
             return (label!,value)
         }).compactMap{ $0 })
         return dict
     }
}


// Get Response


// MARK: - Welcome
struct getVoucherModel: Codable {
    let id, code: String
    let campaign: JSONNull?
    let category, type: String
    let discount: Discount
    let gift, loyaltyCard: JSONNull?
    let startDate, expirationDate: Date
    let validityTimeframe, validityDayOfWeek: JSONNull?
    let publish: Publish
    let redemption: Redemption
    let active: Bool
    let additionalInfo: JSONNull?
    let metadata: Metadata
    let assets: Assets
    let isReferralCode: Bool
    let updatedAt: JSONNull?
    let object: String
    let key : String?
    let message : String?
    let details : String?
    let request_id : String?

    enum CodingKeys: String, CodingKey {
        case id, code, campaign, category, type, discount, gift
        case loyaltyCard = "loyalty_card"
        case startDate = "start_date"
        case expirationDate = "expiration_date"
        case validityTimeframe = "validity_timeframe"
        case validityDayOfWeek = "validity_day_of_week"
        case publish, redemption, active
        case additionalInfo = "additional_info"
        case metadata, assets
        case isReferralCode = "is_referral_code"
        case updatedAt = "updated_at"
        case object
        case key = "key"
        case message = "message"
        case details = "details"
        case request_id = "request_id"
    }
}

// MARK: - Assets
struct Assets: Codable {
    let qr, barcode: Barcode
}

// MARK: - Barcode
struct Barcode: Codable {
    let id: String
    let url: String
}



// MARK: - Publish
struct Publish: Codable {
    let object: String?
    let count: Int?
    let url: String?
}




// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

