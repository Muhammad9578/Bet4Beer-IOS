//
//  BeerCouponVC3.swift
//  Bets4Beers
//
//  Created by iOS Dev on 26/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseDatabase

class BeerCouponVC3: BaseViewController {

    @IBOutlet var dismissPopBtn: UIButton!
    @IBOutlet var imagePopView: UIView!
    @IBOutlet var imageView: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        imagePicker.delegate = self
        views(isShow: true)
        imagePopView.layer.cornerRadius = 3
        imageView.layer.cornerRadius = 3
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        var ref: DatabaseReference?
        ref = Database.database().reference()
        Utility.startLoader()
        FirebaseUtility.uploadMedia(isProfile: false, image: self.image) { (imageUrl) in
            if let imageUrl = imageUrl {
                let user = SharedManager.shared.user
                let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
                let data = [
                    "status": "Pending",
                    "surveyName": "Tier 3",
                    "timeStamp": timeStamp,
                    "screenShotImage": imageUrl,
                    "email": user?.email ?? "",
                    "userName": user?.userName ?? "",
                    "uid": user?.uid ?? ""
                    ] as [String : Any]
                ref?.child(Strings.screenShots).childByAutoId().setValue(data, withCompletionBlock: { (error, dataRef) in
                    if error == nil {
                        Utility.stopLoader()
                        if #available(iOS 13.0, *) {
                            let vc = self.storyboard?.instantiateViewController(identifier: "ThanksSSVCViewController") as! ThanksSSVCViewController
                            vc.delegate = self
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            self.present(vc, animated: true)
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        
                    }else {
                        Utility.stopLoader()
                        self.showMessageAlert(Strings.error, message: error?.localizedDescription ?? "")
                    }
                })
            }else {
                Utility.stopLoader()
                self.showMessageAlert(Strings.appName, message: Strings.uploadFailed)
            }
        }
    }
    @IBAction func screenshotVerificationClicked(_ sender: Any) {
        showSelectionSheet(imageOrVideo: "image")
    }
    
    @IBAction func registerBETMGM(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string:"https://casino.nj.betmgm.com/en/games")!)
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func closePop(_ sender: Any) {
        views(isShow: true)
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    
}

extension BeerCouponVC3: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicker.dismiss(animated: true, completion: nil)
            self.image = image
            self.imageView.image = image
            views(isShow: false)
        }else {
            
        }
    }
    
    func views(isShow: Bool) {
        if isShow {
            imagePopView.isHidden = true
            dismissPopBtn.isHidden = true
        }else {
            imagePopView.isHidden = false
            dismissPopBtn.isHidden = false
        }
    }
}

extension BeerCouponVC3: ThanksSSDelegate {
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
