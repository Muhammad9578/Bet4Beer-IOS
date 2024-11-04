//
//  SidemenuTBViewCell.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol SideMenuCellDelegate {
    func loadList(with showToken: Bool)
}

class SidemenuTBViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet var arrowImg: UIImageView!
    @IBOutlet var dropDownBtn: UIButton!
    @IBOutlet var leftConstraints: NSLayoutConstraint!
    
    var delegate: SideMenuCellDelegate?
    var showMenu = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func dropDownClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.8) {
            self.showMenu = !self.showMenu
            self.arrowImg.transform = self.arrowImg.transform.rotated(by: .pi)
            self.delegate?.loadList(with: self.showMenu)
        }
    }
    
}
