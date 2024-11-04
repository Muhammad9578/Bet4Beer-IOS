//
//  LocationMO.swift
//  Bets4Beers
//
//  Created by iOS Dev on 16/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class LocationMO: Mappable, Stringify {
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    init(with json: [String: Any]) {
        self.address = json[CodingKeys.address.rawValue] as? String ?? ""
        self.latitude = json[CodingKeys.latitude.rawValue] as? Double ?? 0.0
        self.longitude = json[CodingKeys.longitude.rawValue] as? Double ?? 0.0
    }
}
