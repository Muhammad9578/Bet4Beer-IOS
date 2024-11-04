//
//  CreditRemainingTBViewCell.swift
//  Bets4Beers
//
//  Created by apple on 4/9/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CreditRemainingTBViewCell: UITableViewCell {

    @IBOutlet var quantityRemainingLbl: UILabel!
    @IBOutlet var surveyNameLbl: UILabel!
    @IBOutlet var qrCode: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var survey: SurveyMO? {
        didSet {
            self.qrCode.sd_setImage(with: URL(string: (survey?.qrCode ?? "").replacingOccurrences(of: " ", with: "%20") ), placeholderImage: UIImage(named: "QRCode"))
            self.surveyNameLbl.text = survey?.surveyName ?? ""
            let remainings = (survey?.quantity ?? 0) - (survey?.redemmedQuantity ?? 0)
            self.quantityRemainingLbl.text = "Quantity: \(remainings)"
        }
    }

}
