//
//  Services.swift
//  Bets4Beers
//
//  Created by Murteza on 02/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//


import Foundation
import UIKit

var randomInt = Int.random(in: 1...100)
enum BaseUrl: String
{
    case create_vouchers = "v1/vouchers/"
    case create_customer = "v1/customers"
    case create_compaign = "v1/campaigns"
    case create_publication = "v1/publications"
   
    func toURL () -> String
    {
        return "https://us1.api.voucherify.io/" + self.rawValue
    }
    
    //https://us1.api.voucherify.io/v1/publications
}
