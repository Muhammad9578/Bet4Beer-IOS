//
//  appViews.swift
//  Bets4Beers
//
//  Created by iOS Dev on 05/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    var gps = ""
    override func awakeFromNib() {
        super.awakeFromNib()

        //TODO: Code for our button
    }
}

class PrimaryTF: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.borderWidth = 0.5
    }
}
