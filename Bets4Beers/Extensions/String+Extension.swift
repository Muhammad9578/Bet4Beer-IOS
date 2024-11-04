//
//  String+Extension.swift
//  Bets4Beers
//
//  Created by iOS Dev on 01/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension Int64 {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: (TimeInterval(self))/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    func getTimeFromUTC() -> String {
        let date = Date(timeIntervalSince1970: (TimeInterval(self))/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
