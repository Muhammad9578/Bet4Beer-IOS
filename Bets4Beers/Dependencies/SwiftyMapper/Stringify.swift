//
//  Stringify.swift
//  Bets4Beers
//
//  Created by iOS Dev on 04/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol Stringify: Encodable {
    var json: String? { get }
}
extension Stringify {
    var json: String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        }
        catch (let err) {
            print(err)
            return nil
        }
    }
}
