//
//  ThanksSSVCViewController.swift
//  Bets4Beers
//
//  Created by iOS Dev on 10/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol ThanksSSDelegate {
    func dismiss()
}

class ThanksSSVCViewController: UIViewController {

    var delegate: ThanksSSDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func returnToHom(_ sender: Any) {
        isSurvey3 = true
        self.setRootVC(storyBoard: "SelectSurveyVC")
    }
    
}
