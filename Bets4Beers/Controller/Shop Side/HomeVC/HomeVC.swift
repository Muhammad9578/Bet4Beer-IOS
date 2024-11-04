//
//  HomeVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SideMenu

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.8), 240)
    }

}
