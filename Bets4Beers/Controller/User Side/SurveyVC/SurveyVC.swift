//
//  SurveyVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAuth
import Alamofire

protocol SideMenuDelegate {
    func logoutClick()
}

class SurveyVC: UIViewController {

    @IBOutlet var gamblingMainView: UIView!
    
    var slected_comapign_name:String = ""
    var slected_voucher_Code:String = ""
    var slected_voucher_ID:String = ""
     var slected_voucher_Qr:String = ""
     var customer_source_id:String = ""
     var customer_name:String = ""
    var customer_email:String = ""
    var quantity:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = SharedManager.shared.user
        customer_name = user?.userName ?? ""
        customer_email = user?.email ?? ""
        if !SharedManager.shared.isDataLoaded {
            SharedManager.shared.isDataLoaded = true
            FirebaseUtility.getAllSurveys()
            FirebaseUtility.getScreenShot()
        }
        if UserDefaults.standard.string(forKey: "SurveyOption") != nil {
            self.setRootVC(storyBoard: "SidemenuVC")
        }else if UserDefaults.standard.string(forKey: "SurveyOptionNo") != nil {
            self.setRootVC(storyBoard: "SidemenuVC")
        }
        // Do any additional setup after loading the view.
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.8), 240)
         nowFrom = "takeServey"
        gamblingMainView.layer.cornerRadius = 3
        getMyData()
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserData), name: .loadMyData, object: nil)
    }
    
    @IBAction func sideMenuClicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "SidemenuVC") as! SidemenuVC
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func checkUserData() {
        if SharedManager.shared.isLoggedIn {
            print("ok")
        }else {
            self.showMessageAlert(Strings.appName, message: Strings.noSuchUser) { (_) in
                self.logoutClick()
            }
        }
    }
    
    func getMyData() {
        FirebaseUtility.getMyData()
    }
    
    
    @IBAction func yesClicked(_ sender: Any) {
        UserDefaults.standard.set("SurveyOption", forKey: "SurveyOption")
        self.setRootVC(storyBoard: "SidemenuVC")
    }
    @IBAction func noClicked(_ sender: Any) {
        if FirstTimne{
            UserDefaults.standard.set("SurveyOptionNo", forKey: "SurveyOptionNo")
            self.postvoucherOrder()
        }else{
            Alert.showBasic(title: "", message: "Thank you for your answer.", vc: self)
        }
    }
    @IBAction func potentiallyClicked(_ sender: Any) {
        UserDefaults.standard.set("SurveyOption", forKey: "SurveyOption")
        self.setRootVC(storyBoard: "SidemenuVC")
    }
    
    
    
    //MARK:- Actions
    @IBAction func takeSurveyBtnClicked(_ sender: UIButton) {
        
    }

}

extension SurveyVC: SideMenuDelegate {
    func logoutClick() {
        logout()
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
        self.dismiss(animated: true, completion: nil)
    }
}

extension SurveyVC {
    
    // <------------------------------- Create Voucher ------------------------------ >
    func postvoucherOrder(){
        let dic = self.createvoucherParams()
        let post =   self.pasrseString(dic: dic)
        DispatchQueue.main.async {
            self.CreateVocher(postringstring: post)
            
        }
    }
    
    
    // func create valid parameter
    
    func createvoucherParams()->postVocherModel{
        let redemption = Redemption.init(quantity: quantity)
        let conde_config = Code_config.init(pattern: "PROMO-#####")
        let discount = Discount.init(percent_off: 100, type: "PERCENT")
        let metadata = Metadata.init(test: true, locale: "de-en")
        let postVC =  postVocherModel.init(category: "New Customers1", type: "DISCOUNT_VOUCHER", discount: discount, start_date: "\(gettodayDate())", expiration_date: "2025-02-01T00:10:00Z", redemption: redemption, code_config: conde_config, metadata: metadata)
        return postVC
    }
    
    
    func pasrseString(dic:postVocherModel)->String{
        var json:String = ""
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            //print("json Data  is ------------- \(jsonData)")
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                //print("json string is ------------- \(jsonString)")
                json = jsonString
            }
            // json = jsonData
        }
        return json
    }
    
    // func create valid parameter
    func CreateVocher(postringstring:String){
        //let parameters: [String: Any] = [:]
        ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
        let urlString = BaseUrl.create_vouchers.toURL()
        print(" url is    \(urlString)")
        let url = URL.init(string: "\(urlString)")
        var request = URLRequest(url:url!)
        
        
        request.setValue("2986fb82-6dae-4e5b-a070-ec57e8849b84", forHTTPHeaderField: "X-App-Id")
        request.setValue("90bf01af-4ac2-4d0e-970d-04ff3a639bfb", forHTTPHeaderField: "X-App-Token")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.httpBody = postringstring.data(using: .utf8)
        
        Alamofire.request(request).responseJSON { response in
            
            
            switch response.result
            {
                
            case .success(let json):
                // activityIndicators.stopAnimating()
                let jsonData = json
                print(jsonData)
                if let JSON = response.result.value {
                    print("JSON fee Result is : \(JSON)")
                    do {
                        ActivityIndicator.shared.hideLoadingIndicator()
                        let res = JSON as! NSDictionary
                        // print("id ---- \(res.object(forKey: "id"))")
                        self.slected_voucher_ID = res.object(forKey: "id") as! String
                        print("id --------- \(self.slected_voucher_ID)")
                        let assets =  res.object(forKey: "assets") as! NSDictionary
                        let qrobj = assets.object(forKey: "qr") as! NSObject
                        self.slected_voucher_Qr = qrobj.value(forKey: "url") as! String
                        print("Qr url  --------- \(self.slected_voucher_Qr)")
                        UserDefaults.standard.set(self.slected_voucher_Qr, forKey: "qr")
                        self.slected_voucher_ID = res.object(forKey: "id") as! String
                        self.slected_voucher_Code = res.object(forKey: "code") as! String
                        UserDefaults.standard.set(self.slected_voucher_Code, forKey: "survey")
                        print("Voucher code is -------- \(self.slected_voucher_Code)")
                        
                        
                        self.postCustomerOrder()
                        
                    } catch let error {
                        ActivityIndicator.shared.hideLoadingIndicator()
                        print("error is \(error.localizedDescription)")
                        
                    }
                }
                
            case .failure(let error):
                // activityIndicators.stopAnimating()
                //self.showToast(message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
    
    // <------------------------------- Create customer ------------------------------ >
    func postCustomerOrder(){
        let dic = self.creatCustomerParams()
        let post =   self.pasrseCustomerString(dic: dic)
        DispatchQueue.main.async {
            
            self.CreateCustomer(postringstring: post)
            
        }
    }
    
    
    // func create valid parameter
    
    func creatCustomerParams()->customerModel{
        let address = Address.init(city: "Rwp", state: "Pakistan", line_1: "comercial", line_2: "market", country: "Pakistsn", postal_code: "46000")
        let meta = Metadatas.init(lang: "en")
        let postVC =  customerModel.init(source_id: self.slected_voucher_ID, name: "\(customer_name) - voucher", email: customer_email, address: address, description: "Helo \(customer_name)", metadata: meta)
        return postVC
    }
    
    
    func pasrseCustomerString(dic:customerModel)->String{
        var json:String = ""
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            //print("json Data  is ------------- \(jsonData)")
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                //print("json string is ------------- \(jsonString)")
                json = jsonString
            }
            // json = jsonData
        }
        return json
    }
    
    // func create valid parameter
    func CreateCustomer(postringstring:String){
        //let parameters: [String: Any] = [:]
        ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
        let urlString = BaseUrl.create_customer.toURL()
        print(" url is    \(urlString)")
        let url = URL.init(string: "\(urlString)")
        var request = URLRequest(url:url!)
        
        
        request.setValue("2986fb82-6dae-4e5b-a070-ec57e8849b84", forHTTPHeaderField: "X-App-Id")
        request.setValue("90bf01af-4ac2-4d0e-970d-04ff3a639bfb", forHTTPHeaderField: "X-App-Token")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.httpBody = postringstring.data(using: .utf8)
        
        Alamofire.request(request).responseJSON { response in
            
            
            switch response.result
            {
                
            case .success(let json):
                // activityIndicators.stopAnimating()
                let jsonData = json
                print(jsonData)
                if let JSON = response.result.value {
                    print("JSON fee Result is : \(JSON)")
                    do {
                        ActivityIndicator.shared.hideLoadingIndicator()
                        let res = JSON as! NSDictionary
                        self.customer_source_id = res.object(forKey: "source_id") as! String
                        print("source id ------------- \(self.customer_source_id)")
                        print("customer name ------------- \(res.object(forKey: "name") as! String)")
                        print("customer email ------------- \(res.object(forKey: "email") as! String)")
                        self.customer_name = res.object(forKey: "name") as! String
                        self.customer_email = res.object(forKey: "email") as! String
                        // if servey one is completed
                        if nowFrom == "s1complete"{
                            
                        }else {
                            self.setRootVC(storyBoard: "SidemenuVC")
                        }
                    } catch let error {
                        ActivityIndicator.shared.hideLoadingIndicator()
                        print("error is \(error.localizedDescription)")
                        
                    }
                }
                
            case .failure(let error):
                // activityIndicators.stopAnimating()
                //self.showToast(message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    // --------------- Date Externsion ------------------- //
    func gettodayDate()->String{
        let today = Date()
        var  datestring = today.toString(dateFormat: "yyyy-MM-dd")
        datestring +=  "T00:00:00Z"
        print("date change is -- \(datestring)")
        return datestring
    }
    
}
