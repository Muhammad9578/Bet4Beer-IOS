//
//  LoginVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: BaseViewController {

    //MARK:- Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var resetPasswordBtn: UIButton!
    @IBOutlet var singupBtn: UIButton!
    
    private var isValidated: Bool {
        guard let email = emailTF.text?.trim,
            let password = passwordTF.text?.trim           else {
                return false
        }
        var errorMessage: String?
        if email.isEmpty {
            errorMessage = Strings.emailRequired
        }
        else if !email.isValidEmail {
            errorMessage = Strings.emailInvalid
        }
        else if password.isEmpty {
            errorMessage = Strings.passwordRequired
        }
        
        if let errorMessage = errorMessage {
            showMessageAlert(Strings.error, message: errorMessage)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 3
        
        let attributeStringresetPass = NSMutableAttributedString(string: "Reset password",
                                                        attributes: btnUnderlineAttributes)
        resetPasswordBtn.setAttributedTitle(attributeStringresetPass, for: .normal)
        let attributeStringSignup = NSMutableAttributedString(string: "SIGNUP",
                                                        attributes: btnUnderlineAttributes)
        singupBtn.setAttributedTitle(attributeStringSignup, for: .normal)
    }
    
    //MARK:- Actions
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        self.NextViewController(storybordid: "ForgetPasswordVC")
    }
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        if isValidated {
            Utility.startLoader()
            guard let email = emailTF.text,
                let password = passwordTF.text
                else {
                    return
            }
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error == nil {
                    if let user = Auth.auth().currentUser,
                        !user.isEmailVerified
                    {
                        Utility.stopLoader()
                        self.showContinueAlert(Strings.appName, message: Strings.emailNotVerified, continueHandler: { (UIAlertAction) in
                            user.sendEmailVerification(completion: nil)
                        }, cancelHandler: nil, continueTitle: "Yes", cancelTitle: "No")
                    }else {
                        UserDefaults.standard.set(password, forKey: UserDefaultKeys.userPassword)
                        Utility.stopLoader()
                        self.NextViewController(storybordid: "SelectSurveyVC")
                    }
                }else {
                    Utility.stopLoader()
                    self.showMessageAlert(Strings.appName, message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    @IBAction func signupBtnClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    
}
  

