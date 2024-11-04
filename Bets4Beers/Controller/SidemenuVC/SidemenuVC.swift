//
//  SidemenuVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SidemenuVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var isSideMenu = false
    
    //MARK:- Variables
    
    //MARK:- Arrays
    var openMenuImages:[String] = ["i_home","i_location","i_token","i_token", "i_token","i_share","i_profile","i_logout"]
    var openMenuNames:[String] = ["Home","Map","Tokens","Tokens Received", "Tokens Remaining", "Referal Code", "Profile", "Logout"]
    
    var closedMenuImages:[String] = ["i_home","i_location","i_token","i_share","i_profile","i_logout"]
    var closedMenuNames:[String] = ["Home","Map","Tokens","Referal Code", "Profile", "Logout"]
    
    var delegate: SideMenuDelegate?
    var menuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !SharedManager.shared.isDataLoaded {
            SharedManager.shared.isDataLoaded = true
            FirebaseUtility.getAllSurveys()
            FirebaseUtility.getScreenShot()
        }
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
    }
    
    
    

}
extension SidemenuVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuOpen {
            return openMenuNames.count
        }
        return closedMenuNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidemenuTBViewCell", for: indexPath) as! SidemenuTBViewCell
        if indexPath.row == 2 {
            cell.dropDownBtn.isHidden = false
            cell.arrowImg.isHidden = false
        }else {
            cell.dropDownBtn.isHidden = true
            cell.arrowImg.isHidden = true
        }
        
        if menuOpen {
            if indexPath.row == 3 || indexPath.row == 4 {
                cell.leftConstraints.constant = 36
            }else {
                cell.leftConstraints.constant = 16
            }
        }else {
            cell.leftConstraints.constant = 16
        }
        
        cell.delegate = self
        if menuOpen {
            cell.imgView.image = UIImage(named: openMenuImages[indexPath.row])
            cell.textLbl.text = openMenuNames[indexPath.row]
        }else {
            cell.imgView.image = UIImage(named: closedMenuImages[indexPath.row])
            cell.textLbl.text = closedMenuNames[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
             self.setRootVC(storyBoard: "SelectSurveyVC")
        }
        else if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            if !menuOpen {
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReferralsViewController") as! ReferralsViewController
                self.present(vc, animated: true, completion: nil)
            }else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "CreditReceivedVC") as! CreditReceivedVC
                self.present(vc, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 4 {
            if !menuOpen {
                let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
                self.present(vc, animated: true, completion: nil)
            }else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "CreditRemainingVC") as! CreditRemainingVC
                self.present(vc, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 5 {
            if !menuOpen {
                self.showContinueAlert(Strings.appName, message: Strings.sureLogout, continueHandler: { (UIAlertAction) in
                    if self.isSideMenu {
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.logoutClick()
                    }else {
                        self.logout()
                    }
                }, cancelHandler: nil, continueTitle: "Yes", cancelTitle: "No")
            }else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReferralsViewController") as! ReferralsViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 6 {
           let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
           self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 7 {
            self.showContinueAlert(Strings.appName, message: Strings.sureLogout, continueHandler: { (UIAlertAction) in
                //                if self.isSideMenu {
                //                    self.dismiss(animated: true, completion: nil)
                //                    self.delegate?.logoutClick()
                //                }else {
                self.logout()
                //                }
                
            }, cancelHandler: nil, continueTitle: "Yes", cancelTitle: "No")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Something went wrong")
        }
        SharedManager.shared.user = nil
        SharedManager.shared.surveys = []
        SharedManager.shared.isDataLoaded = false
        self.setRootVC(storyBoard: "SplashVC")
    }
}


extension SidemenuVC: SideMenuCellDelegate {
    func loadList(with showToken: Bool) {
        self.menuOpen = showToken
        self.tableView.reloadData()
    }
}
