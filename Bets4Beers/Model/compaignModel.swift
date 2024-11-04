//
//  compaignModel.swift
//  Bets4Beers
//
//  Created by Murteza on 08/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
// Post Data model
struct comapaignModel : Codable {
var name : String?
var start_date : String?
var expiration_date : String?
var vouchers_count : Int?
var voucher : Voucher?
var metadata : Metadatass?

enum CodingKeys: String, CodingKey {

    case name = "name"
    case start_date = "start_date"
    case expiration_date = "expiration_date"
    case vouchers_count = "vouchers_count"
    case voucher = "voucher"
    case metadata = "metadata"
}
}
struct Code_configs : Codable {
var pattern : String?

enum CodingKeys: String, CodingKey {

    case pattern = "pattern"
}
}
struct Discounts : Codable {
var percent_off : String?
var type : String?

enum CodingKeys: String, CodingKey {

    case percent_off = "percent_off"
    case type = "type"
}
}
struct Redemptions : Codable {
var quantity : Int?

enum CodingKeys: String, CodingKey {

    case quantity = "quantity"
}
}
struct Metadatass : Codable {
var test : Bool?

enum CodingKeys: String, CodingKey {

    case test = "test"
}
}
struct Voucher : Codable {
var type : String?
var discount : Discounts?
var redemption : Redemptions?
var code_config : Code_configs?

enum CodingKeys: String, CodingKey {

    case type = "type"
    case discount = "discount"
    case redemption = "redemption"
    case code_config = "code_config"
}
}
