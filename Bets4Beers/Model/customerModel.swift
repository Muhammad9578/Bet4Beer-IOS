//
//  customerModel.swift
//  Bets4Beers
//
//  Created by Murteza on 08/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
// Post Data
struct customerModel : Codable {
var source_id : String?
var name : String?
var email : String?
var address : Address?
var description : String?
var metadata : Metadatas?

enum CodingKeys: String, CodingKey {

    case source_id = "source_id"
    case name = "name"
    case email = "email"
    case address = "address"
    case description = "description"
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

struct Address : Codable {
var city : String?
var state : String?
var line_1 : String?
var line_2 : String?
var country : String?
var postal_code : String?

enum CodingKeys: String, CodingKey {

    case city = "city"
    case state = "state"
    case line_1 = "line_1"
    case line_2 = "line_2"
    case country = "country"
    case postal_code = "postal_code"
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
struct Metadatas : Codable {
var lang : String?

enum CodingKeys: String, CodingKey {

    case lang = "lang"
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

// Get Data
//
//no model Yett
