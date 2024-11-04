//
//  OrderHistoryTBViewCell.swift
//  Bets4Beers
//
//  Created by apple on 4/9/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class OrderHistoryTBViewCell: UITableViewCell {

    @IBOutlet var quantityUsedLbl: UILabel!
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
            self.quantityUsedLbl.text = "Quantity: \(survey?.redemmedQuantity ?? 0)"
        }
    }
    
}
