//
//  ViewController.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var splashImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.splashImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 2, animations:{
            self.splashImage.transform = .identity
        }) { (true) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
                self.performSegue(withIdentifier: "splashToMain", sender: self)
            }
        }
    }
}

