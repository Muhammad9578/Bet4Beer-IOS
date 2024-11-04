//
//  Mappable.swift
//  Bets4Beers
//
//  Created by iOS Dev on 04/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol Mappable: Decodable {
    init?(jsonString: String)
    init?(data: Data)
}

extension Mappable {
    
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        self.init(data: data)
    }
    
    init?(data: Data) {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        }
        catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
