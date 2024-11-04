//
//  ReferralsViewController.swift
//  Bets4Beers
//
//  Created by iOS Dev on 14/08/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ReferralsViewController: UIViewController {

    @IBOutlet var referNowBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        referNowBtn.layer.cornerRadius = 3
    }
    
    @IBAction func referNowClicked(_ sender: Any) {
        share()
    }
    
    func share() {
        let text = "Click on link to download app and use referral code on Sign Up page to get free token.\nReferral code: \(SharedManager.shared.user?.uid ?? "")\nhttps://play.google.com/store/apps/details?id=com.example.beershop"
        let textShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
