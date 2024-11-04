//
//  ThankUVC.swift
//  Bets4Beers
//
//  Created by Murteza on 17/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ThankUVC: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    var qr_url:String = ""
    var isNoSurveyAdded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQr(qrU: "")
        setUpSurveys()
        NotificationCenter.default.addObserver(self, selector: #selector(setUpSurveys), name: .loadMySurveys, object: nil)
    }
    
    @objc func setUpSurveys() {
        for single in SharedManager.shared.surveys {
            if single.surveyName == "Gift Card" {
                loadQr(qrU: single.qrCode ?? "")
            }
        }
    }
    
    func loadQr(qrU: String) {
        if qrU == "" {
            FirstTimne = false
            if let qr_url = UserDefaults.standard.string(forKey: "qr"), !isNoSurveyAdded, let code = UserDefaults.standard.string(forKey: "survey") {
                UserDefaults.standard.removeObject(forKey: "qr")
                UserDefaults.standard.removeObject(forKey: "survey")
                isNoSurveyAdded = true
                FirebaseUtility.sendQrCodeData(survey: "Gift Card", qr: qr_url, vc: self, surveyCode: code)
            }
        }else {
            qr_url = qrU
        }
        self.qrImage.sd_setImage(with: URL(string: qr_url.replacingOccurrences(of: " ", with: "%20") ), placeholderImage: UIImage(named: "QRCode"))
    }

  
    @IBAction func backBtn(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "SidemenuVC") as! SidemenuVC
            vc.isSideMenu = true
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension ThankUVC: SideMenuDelegate {
    func logoutClick() {
        logout()
        self.setRootVC(storyBoard: "SplashVC")
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Something went wrong")
        }
        SharedManager.shared.user = nil
        SharedManager.shared.surveys = []
        SharedManager.shared.isDataLoaded = false
        self.dismiss(animated: true, completion: nil)
    }
}
