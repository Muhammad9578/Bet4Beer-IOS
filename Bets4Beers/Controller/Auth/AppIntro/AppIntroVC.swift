//
//  AppIntroVC.swift
//  Bets4Beers
//
//  Created by apple on 4/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AppIntroVC: UIViewController {

    @IBOutlet var popView: UIView!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popView.layer.cornerRadius = 20
//        popView.dropShadow(color: UIColor.black, opacity: 0.2, offSet: CGSize(width: 0, height: 1), radius: 4, scale: true)
        registerBtn.layer.cornerRadius = 3
        setUpView()
        self.view.isUserInteractionEnabled = true
        print(loginBtn.isEnabled)
    }
//    UserDefaults.standard.set("SurveyOption", forKey: "SurveyOption")
    
    func setUpView() {
        if SharedManager.shared.isLoggedIn {
//            if UserDefaults.standard.string(forKey: "SurveyOption") != nil {
//                self.setRootVC(storyBoard: "SidemenuVC")
//            }else if UserDefaults.standard.string(forKey: "SurveyOptionNo") != nil {
//                self.setRootVC(storyBoard: "SidemenuVC")
//            }else {
//                self.NextViewController(storybordid: "SurveyVC")
//            }
            SharedManager.shared.isDataLoaded = true
            FirebaseUtility.getAllSurveys()
            FirebaseUtility.getScreenShot()
            self.setRootVC(storyBoard: "SelectSurveyVC")
        }
        
        let attributeStringLogin = NSMutableAttributedString(string: "login to existing account",
                                                        attributes: btnUnderlineAttributes)
        loginBtn.setAttributedTitle(attributeStringLogin, for: .normal)
    }
    @IBAction func letsGoClicked(_ sender: UIButton) {
        self.NextViewController(storybordid: "LoginVC")
    }
    @IBAction func signUpClicked(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
//        self.present(vc, animated: true, completion: nil)
        self.NextViewController(storybordid: "SignupVC")
    }
    
}
