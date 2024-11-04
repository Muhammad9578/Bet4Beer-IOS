//
//  PublicationModel.swift
//  Bets4Beers
//
//  Created by Murteza on 08/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
struct PblicationPostMdel : Codable {
let campaign : Campaign?
let customer : Customer?
let metadata : Metadat?
let voucher : String?

enum CodingKeys: String, CodingKey {

    case campaign = "campaign"
    case customer = "customer"
    case metadata = "metadata"
    case voucher = "voucher"
}
}
struct Campaign : Codable {
let name : String?
let count : Int?

enum CodingKeys: String, CodingKey {

    case name = "name"
    case count = "count"
}
}
struct Customer : Codable {
let source_id : String?
let email : String?
let name : String?

enum CodingKeys: String, CodingKey {

    case source_id = "source_id"
    case email = "email"
    case name = "name"
}
}
struct Metadat : Codable {
let test : Bool?
let provider : String?

enum CodingKeys: String, CodingKey {

    case test = "test"
    case provider = "provider"
}
}
