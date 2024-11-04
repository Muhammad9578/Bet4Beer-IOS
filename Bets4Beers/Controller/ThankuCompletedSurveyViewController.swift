//
//  ThankuCompletedSurveyViewController.swift
//  Bets4Beers
//
//  Created by iOS Dev on 12/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class ThankuCompletedSurveyViewController: UIViewController {

    @IBOutlet var qrCode: UIImageView!
    @IBOutlet var mainView: UIView!
    
    var qrcodeStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 5
        self.qrCode.sd_setImage(with: URL(string: qrcodeStr.replacingOccurrences(of: " ", with: "%20") ), placeholderImage: UIImage(named: "QRCode"))
    }
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
