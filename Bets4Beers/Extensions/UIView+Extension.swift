//
//  UIView+Extension.swift
//  Bets4Beers
//
//  Created by iOS Dev on 05/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension UIView {
    func roundView() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
