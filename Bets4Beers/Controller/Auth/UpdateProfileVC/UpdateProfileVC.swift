//
//  UpdateProfileVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UpdateProfileVC: BaseViewController {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var image:UIImage?
    private var isValidated: Bool {
        guard let name = nameTextField.text?.trim,
            let email = emailTextField.text?.trim
            else {
                return false
        }
        var errorMessage: String?
        if name.isEmpty {
            errorMessage = Strings.nameRequired
        }
        else if email.isEmpty {
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
        setDataInViews()
        NotificationCenter.default.addObserver(self, selector: #selector(setDataInViews), name: .loadMyData, object: nil)
    }
    
    @objc func setDataInViews() {
        imagePicker.delegate = self
        imageView.roundView()
        let user = SharedManager.shared.user
        nameTextField.text = user?.userName ?? ""
        emailTextField.text = user?.email ?? ""
        if let profile = user?.profileImage {
            let profileUrl = URL(string: profile)
            imageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "user"), options: .refreshCached, context: nil)
        }else {
            imageView.image = UIImage(named: "user")
        }
    }
    
    @IBAction func uploadImageClicked(_ sender: Any) {
        showSelectionSheet(imageOrVideo: "image")
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        Utility.startLoader()
        guard let email = emailTextField.text
            else {
                return
        }
        
        let user = Auth.auth().currentUser
        let localUser = SharedManager.shared.user
        let password = UserDefaults.standard.string(forKey: UserDefaultKeys.userPassword)
        let credentials = EmailAuthProvider.credential(withEmail: localUser?.email ?? "", password: password ?? "")
        user?.reauthenticate(with: credentials, completion: { (refResult, er) in
            if er == nil {
                Auth.auth().currentUser?.updateEmail(to: email, completion: { (err) in
                    if err == nil {
                        if self.image != nil {
                            FirebaseUtility.uploadMedia(isProfile: true, image: self.image) { (imageUrl) in
                                self.uploadProfileData(imageUrl: imageUrl)
                            }
                        }else {
                            self.uploadProfileData(imageUrl: "")
                        }
                    }
                    else {
                        Utility.stopLoader()
                        self.showMessageAlert(Strings.error, message: err?.localizedDescription ?? "")
                    }
                })
            }else {
                print(er?.localizedDescription ?? "")
            }
        })
    }
    
    func uploadProfileData(imageUrl: String?) {
        guard let name = nameTextField.text,
            let email = emailTextField.text
            else {
                return
        }
        let user = SharedManager.shared.user
        let data = [
            "email": email,
            "userName": name,
            "profileImage": imageUrl ?? ""
        ]
        var ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.users).child(user?.uid ?? "").updateChildValues(data, withCompletionBlock: { (eror, dataRef) in
            if eror == nil {
                Utility.stopLoader()
                self.showMessageAlert(Strings.appName, message: Strings.profileUpdateSuccess)
            }else {
                Utility.stopLoader()
                self.showMessageAlert(Strings.error, message: eror?.localizedDescription ?? "")
            }
        })
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
 
}

extension UpdateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicker.dismiss(animated: true, completion: nil)
            self.image = image
            imageView.image = image
        }else {
            
        }
    }
}
