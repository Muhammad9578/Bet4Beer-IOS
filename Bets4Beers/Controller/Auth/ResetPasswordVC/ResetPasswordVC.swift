//
//  ResetPasswordVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgetPasswordVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var emailTF: UITextField!
    
    private var isValidated: Bool {
        guard let email = emailTF.text?.trim
            else {
                return false
        }
        var errorMessage: String?
        if email.isEmpty {
            errorMessage = Strings.emailRequired
        }
        else if !email.isValidEmail {
            errorMessage = Strings.emailInvalid
        }
        
        if let errorMessage = errorMessage {
            showMessageAlert(Strings.error, message: errorMessage)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        emailTF.layer.borderWidth = 1.5
    }
    @IBAction func resetPasswordClicked(_ sender: Any) {
        if isValidated {
            guard let email = emailTF.text?.trim
                else {
                    return
            }
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    self.showMessageAlert(Strings.appName, message: Strings.passwordResetLinkSent)
                }else {
                    self.showMessageAlert(Strings.appName, message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    @IBAction func dismissBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
