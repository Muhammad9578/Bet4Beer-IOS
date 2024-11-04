//
//  CreditReceivedTBViewCell.swift
//  Bets4Beers
//
//  Created by apple on 4/9/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CreditReceivedTBViewCell: UITableViewCell {

    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var surveyNameLbl: UILabel!
    @IBOutlet var qrImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var survey: SurveyMO? {
        didSet {
            self.qrImage.sd_setImage(with: URL(string: (survey?.qrCode ?? "").replacingOccurrences(of: " ", with: "%20") ), placeholderImage: UIImage(named: "QRCode"))
            self.surveyNameLbl.text = "\(survey?.surveyName ?? "")"
            self.dateLbl.text = "Quantity: \(survey?.quantity ?? 0)"
        }
    }
}
