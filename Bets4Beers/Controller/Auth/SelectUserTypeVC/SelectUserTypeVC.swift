//
//  SelectUserTypeVC.swift
//  Bets4Beers
//
//  Created by apple on 4/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
class SelectUserTypeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.postOrder()
    }
    
    @IBAction func ownerClicked(_ sender: UIButton) {
        userType = 0
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.present(vc, animated: true, completion: nil)
        self.NextViewController(storybordid: "LoginVC")
        
    }
    @IBAction func customerClicked(_ sender: UIButton) {
        userType = 1
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.present(vc, animated: true, completion: nil)
          self.NextViewController(storybordid: "LoginVC")
    }
    
    
}
