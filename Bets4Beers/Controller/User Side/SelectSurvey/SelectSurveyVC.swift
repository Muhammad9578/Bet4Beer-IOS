//
//  SelectSurveyVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth

class SelectSurveyVC: UIViewController,SMFeedbackDelegate {
    
    var surveyMonkeyfeedback1:SMFeedbackViewController?
    var surveyMonkeyfeedback2:SMFeedbackViewController?
    
    var slected_comapign_name:String = ""
    var slected_voucher_Code:String = ""
    var slected_voucher_ID:String = ""
    var slected_voucher_Qr:String = ""
    var customer_source_id:String = ""
    var customer_name:String = ""
    var customer_email:String = ""
    var quantity:Int = 1
    var surveys = [SurveyMO]()
    var ss = ScreenShotMO(with: [:])
    
    @IBOutlet var tier3Back: ShadowView!
    @IBOutlet var tier2Back: ShadowView!
    @IBOutlet var tier1Back: ShadowView!
    @IBOutlet weak var btn2Image: UIImageView!
    @IBOutlet var btn3Image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyData()
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserData), name: .loadMyData, object: nil)
        Utility.startLoader()
        FirebaseUtility.getScreenShot()
        FirebaseUtility.getAllSurveys()
        
        self.surveyMonkeyfeedback1 = SMFeedbackViewController(survey: "6WJ2KQR")
        self.surveyMonkeyfeedback1?.delegate = self
                self.surveyMonkeyfeedback1?.scheduleIntercept(from: self, withAppTitle: "Tier 1")
        
        self.surveyMonkeyfeedback2 = SMFeedbackViewController(survey: "ZFWXRTM")
        self.surveyMonkeyfeedback2?.delegate = self
                self.surveyMonkeyfeedback2?.scheduleIntercept(from: self, withAppTitle: "Tier 2")
        // Do any additional setup after loading the view.
        customer_name = SharedManager.shared.user?.userName ?? ""
        customer_email = SharedManager.shared.user?.email ?? ""
        print(self.gettodayDate())
        self.loadSurveys()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadSurveys), name: .loadMySurveys, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadSurveys), name: .loadSS, object: nil)
        
        if let _ = Utility.getSurvey(surveyId: "Tier 3") ,
            let _ = SharedManager.shared.screenShot
        {
            
        }else {
            if isSurvey3 {
                self.survey3ApiCall()
            }
        }
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadSurveys()
//    }
    
    @objc func loadSurveys() {
        Utility.stopLoader()
        surveys = SharedManager.shared.surveys
        ss = SharedManager.shared.screenShot
        if surveys.count != 0 && isSurveyLoaded {
            if Utility.isSurveyExist(surveyId: "Tier 1") , !Utility.isSurveyExist(surveyId: "Tier 2"){
                nowFrom = "servey2"
                tier1Back.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2, blue: 0.5333333333, alpha: 1)
                tier2Back.backgroundColor = #colorLiteral(red: 0.02348791435, green: 0.6567551494, blue: 1, alpha: 1)
                servey2ApiCall()
            }
            if Utility.isSurveyExist(surveyId: "Tier 2"), Utility.isSurveyExist(surveyId: "Tier 1") {
                tier1Back.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2, blue: 0.5333333333, alpha: 1)
                tier2Back.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2, blue: 0.5333333333, alpha: 1)
                tier3Back.backgroundColor = #colorLiteral(red: 0.02348791435, green: 0.6567551494, blue: 1, alpha: 1)
                nowFrom = "survey3"
            }
            if Utility.isSurveyExist(surveyId: "Tier 3") {
                if ss?.status == "approved" {
                    tier3Back.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2, blue: 0.5333333333, alpha: 1)
                }
            }
        }else if isSurveyLoaded {
            if !Utility.isSurveyExist(surveyId: "Tier 1") {
                tier1Back.backgroundColor = #colorLiteral(red: 0.02348791435, green: 0.6567551494, blue: 1, alpha: 1)
                tier2Back.backgroundColor = .lightGray
                tier3Back.backgroundColor = .lightGray
                postvoucherOrder()
            }
        }
    }
    
    func respondentDidEndSurvey(_ respondent: SMRespondent!, error: Error!) {
        if error != nil{
            //            Alert.showBasic(title: "", message: error.localizedDescription, vc: self)
        }else{
            switch respondent {
            case .some(let respondent):
                print(respondent.questionResponses!)
            default:
                print(respondent.dateStarted!)
            }
            // call api
            self.postcomapaignOrder()
        }
    }
    
    func callServey1() {
        nowFrom = ""
        quantity = 1
        slected_comapign_name = "survey One Comapaign"
        surveyMonkeyfeedback1?.navigationController?.pushViewController(self, animated: true)
        surveyMonkeyfeedback1?.present(from: self, animated: true, completion: nil)
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "SidemenuVC") as! SidemenuVC
            vc.delegate = self
            vc.isSideMenu = true
            self.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    //MARK:- Actions
    @IBAction func surveyOneClicked(_ sender: UIButton) {
        if Utility.isSurveyExist(surveyId: "Tier 1") {
            if let survey1 = Utility.getSurvey(surveyId: "Tier 1")
            {
                UserDefaults.standard.set(survey1.qrCode, forKey: "qr")
                self.NextViewController(storybordid: "BeerCouponVC")
            }
        }else {
            self.callServey1()
        }
    }
    
    func presentThanku(qrStr: String) {
        let thankuViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ThankuCompletedSurveyViewController.self)) as! ThankuCompletedSurveyViewController
        thankuViewController.modalTransitionStyle = .crossDissolve
        thankuViewController.modalPresentationStyle = .overFullScreen
        thankuViewController.qrcodeStr = qrStr
        self.present(thankuViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func survey2Clicked(_ sender: UIButton) {
        //nowFrom = ""
        if Utility.isSurveyExist(surveyId: "Tier 1") {
            if let survey2 = Utility.getSurvey(surveyId: "Tier 2")
            {
                UserDefaults.standard.set(survey2.qrCode, forKey: "qr")
                self.goToBeerCoupon()
            }else {
                surveyMonkeyfeedback2?.navigationController?.pushViewController(self, animated: true)
                surveyMonkeyfeedback2?.present(from: self, animated: true, completion: nil)
            }
        }else {
            showMessageAlert(Strings.appName, message: "Please complete tier one.")
        }
    }
    
    @IBAction func survey3Clicked(_ sender: UIButton) {
        if ss?.status == "Pending" {
            self.NextViewController(storybordid: "ThanksSSVCViewController")
        }
        else if ss?.status == "approved"{
            if let survey3 = Utility.getSurvey(surveyId: "Tier 3") {
                UserDefaults.standard.set(survey3.qrCode, forKey: "qr")
                self.NextViewController(storybordid: "BeerC3")
            }
        }
        else {
            if Utility.isSurveyExist(surveyId: "Tier 1"),
                Utility.isSurveyExist(surveyId: "Tier 2") {
                self.NextViewController(storybordid: "BeerCouponVC3")
            }else {
                showMessageAlert(Strings.appName, message: "Please complete both tier one and two.")
            }
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
    
    func servey2ApiCall (){
        quantity = 3
        customer_name =  "servey 2 Customer"
        customer_email = "servey2@gmail.com"
        slected_comapign_name = "survey two Comapaign"
        self.postvoucherOrder()
    }

    func survey3ApiCall() {
        quantity = 10
        customer_name =  "servey 3 Customer"
        customer_email = "servey3@gmail.com"
        slected_comapign_name = "survey three Comapaign"
        self.postvoucherOrder()
    }
    
}

extension SelectSurveyVC{
    
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
                let j = jsonData as? NSDictionary ?? [:]
                let message = j["message"] as? String ?? ""
                if message == "Payment required" {
                    ActivityIndicator.shared.hideLoadingIndicator()
                    self.alertMessageShow(title: "Server error", msg: message)
                }else {
                    if let JSON = response.result.value {
                        print("JSON fee Result is : \(JSON)")
                        do {
                            ActivityIndicator.shared.hideLoadingIndicator()
                            let res = JSON as! NSDictionary
                            // print("id ---- \(res.object(forKey: "id"))")
                            self.slected_voucher_ID = res.object(forKey: "id") as? String ?? ""
                            print("id --------- \(self.slected_voucher_ID)")
                            if  let assets =  res.object(forKey: "assets") as? NSDictionary {
                                let qrobj = assets.object(forKey: "qr") as! NSObject
                                self.slected_voucher_Qr = qrobj.value(forKey: "url") as? String ?? ""
                                print("Qr url  --------- \(self.slected_voucher_Qr)")
                                UserDefaults.standard.set(self.slected_voucher_Qr, forKey: "qr")
                                self.slected_voucher_ID = res.object(forKey: "id") as! String
                                self.slected_voucher_Code = res.object(forKey: "code") as! String
                                print("Voucher code is -------- \(self.slected_voucher_Code)")
                                self.postCustomerOrder()
                            }
                            
                        } catch let error {
                            ActivityIndicator.shared.hideLoadingIndicator()
                            print("error is \(error.localizedDescription)")
                            
                        }
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
                let j = jsonData as? NSDictionary ?? [:]
                let message = j["message"] as? String ?? ""
                if message == "Payment required" {
                    ActivityIndicator.shared.hideLoadingIndicator()
                    self.alertMessageShow(title: "Server error", msg: message)
                }else {
                    if let JSON = response.result.value {
                        print("JSON fee Result is : \(JSON)")
                        do {
                            ActivityIndicator.shared.hideLoadingIndicator()
                            let res = JSON as! NSDictionary
                            self.customer_source_id = res.object(forKey: "source_id") as? String ?? ""
                            print("source id ------------- \(self.customer_source_id)")
                            print("customer name ------------- \(res.object(forKey: "name") as? String ?? "")")
                            print("customer email ------------- \(res.object(forKey: "email") as? String ?? "")")
                            self.customer_name = res.object(forKey: "name") as? String ?? ""
                            self.customer_email = res.object(forKey: "email") as? String ?? ""
                            // if servey one is completed
                            if nowFrom == "s1complete"{
                                self.surveyMonkeyfeedback2?.present(from: self, animated: true, completion: nil)
                                
                                //                                    self.surveyMonkeyfeedback2?.navigationController?.pushViewController(self, animated: true)
                            }else {
                                if isSurvey3 {
                                    self.postcomapaignOrder()
                                }
                            }
                        } catch let error {
                            ActivityIndicator.shared.hideLoadingIndicator()
                            print("error is \(error.localizedDescription)")
                            
                        }
                    }
                }
                
            case .failure(let error):
                // activityIndicators.stopAnimating()
                //self.showToast(message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
}

extension SelectSurveyVC: SideMenuDelegate {
    func logoutClick() {
        logout()
        self.setRootVC(storyBoard: "SplashVC")
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


extension SelectSurveyVC{
    // , BeerCouponDelegate--------------------------------- create compaigin ------------------------//
    
     func postcomapaignOrder(){
             let dic = self.createComapaignParams()
             let post =   self.pasrseComapaignString(dic: dic)
             DispatchQueue.main.async {
                 
                 self.CreateCompaign(postringstring: post)
                 
             }
         }
         
         
         // func create valid parameter
         
         func createComapaignParams()->comapaignModel {
            let redemption = Redemptions.init(quantity: 1)
            let code_configs = Code_configs.init(pattern: "TC6-PROMO-#######")
            let discocunt = Discounts.init(percent_off: "100", type: "PERCENT")
            let metadata = Metadatass.init(test: true)
            let voucher = Voucher.init(type: "DISCOUNT_VOUCHER", discount: discocunt, redemption: redemption, code_config: code_configs)
            let postVC =  comapaignModel.init(name: " \(customer_name)\(slected_comapign_name)\(randomInt)", start_date: gettodayDate(), expiration_date: "2023-12-26T00:00:00Z", vouchers_count: quantity, voucher: voucher, metadata: metadata)
             return postVC
         }
         
         
         func pasrseComapaignString(dic:comapaignModel)->String{
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
         func CreateCompaign(postringstring:String){
             //let parameters: [String: Any] = [:]
             ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
               let urlString = BaseUrl.create_compaign.toURL()
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
                        let j = jsonData as? NSDictionary ?? [:]
                        let message = j["message"] as? String ?? ""
                        if message == "Payment required" {
                            ActivityIndicator.shared.hideLoadingIndicator()
                            self.alertMessageShow(title: "Server error", msg: message)
                        }else {
                            if let JSON = response.result.value {
                                print("JSON fee Result is : \(JSON)")
                                do {
                                    ActivityIndicator.shared.hideLoadingIndicator()
                                    let res = JSON as! NSDictionary
                                    
                                    
                                    self.slected_comapign_name = res.object(forKey: "name") as? String ?? ""
                                    print("Compaign Name is ------- \(self.slected_comapign_name)")
                                    self.postPublicationOrder()
                                    
                                } catch let error {
                                    ActivityIndicator.shared.hideLoadingIndicator()
                                    print("error is \(error.localizedDescription)")
                                    
                                }
                            }
                        }
                        
                    case .failure(let error):
                        // activityIndicators.stopAnimating()
                        //self.showToast(message: error.localizedDescription)
                        print(error.localizedDescription)
                    }
                }
            }
    
    
    
     // --------------------------------- create Publication  ------------------------//
        
         func postPublicationOrder(){
                 let dic = self.createPublicationParams()
                 let post =   self.pasrsePublicationString(dic: dic)
                 DispatchQueue.main.async {
                     
                     self.CreatePublication(postringstring: post)
                     
                 }
             }
             
             
             // func create valid parameter
             
             func createPublicationParams()->PblicationPostMdel
             {
                let compaign = Campaign.init(name: self.slected_comapign_name, count: 0)
                let customer = Customer.init(source_id: self.customer_source_id, email: self.customer_email, name: self.customer_name)
                let metadata = Metadat.init(test: true, provider: "Shop Admin")
                let postVC =  PblicationPostMdel.init(campaign: compaign, customer: customer, metadata: metadata, voucher: self.slected_voucher_Code)
                 return postVC
             }
             
             
             func pasrsePublicationString(dic:PblicationPostMdel)->String{
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
             func CreatePublication(postringstring:String){
                 //let parameters: [String: Any] = [:]
                 ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
                   let urlString = BaseUrl.create_publication.toURL()
                    print(" url is    \(urlString)")
                    let url = URL.init(string: "\(urlString)")
                    var request = URLRequest(url:url!)
                    
                    print(urlString)
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
                            let j = jsonData as? NSDictionary ?? [:]
                            let message = j["message"] as? String ?? ""
                            if message == "Payment required" {
                                ActivityIndicator.shared.hideLoadingIndicator()
                                self.alertMessageShow(title: "Server error", msg: message)
                            }else {
                                if let JSON = response.result.value {
                                    print("JSON fee Result is : \(JSON)")
                                    do {
                                        ActivityIndicator.shared.hideLoadingIndicator()
                                        let res = JSON as! NSDictionary
                                        print("result Publication is ---- \(res.object(forKey: "result") as? String ?? "" )")
                                        let result =  res.object(forKey: "result") as? String ?? ""
                                        print(res)
                                        let voucher =  res.object(forKey: "voucher") as? NSDictionary
                                        let code = voucher?["code"] ?? ""
                                        UserDefaults.standard.set(code, forKey: "survey")
                                        let assets =  voucher?.object(forKey: "assets") as? NSDictionary
                                        let qrobj = assets?.object(forKey: "qr") as? NSObject
                                        self.slected_voucher_Qr = qrobj?.value(forKey: "url") as? String ?? ""
                                        UserDefaults.standard.set(self.slected_voucher_Qr, forKey: "qr")
                                        print("Qr url  --------- \(self.slected_voucher_Qr)")
                                        
                                        if result == "SUCCESS"{
                                            //nowFrom = "s1complete"
                                            print("Publication sucessfully  ============")
                                            if isSurvey3 {
                                                isSurvey3 = false
                                                self.sendCoupon3()
                                            }else {
                                                if nowFrom == "servey2"{
                                                    self.NextViewController(storybordid: "BeerCouponVC1")
                                                    
                                                }else{
                                                    self.NextViewController(storybordid: "BeerCouponVC")
                                                }
                                            }
                                        }
                                        
                                        
                                        
                                    } catch let error {
                                        ActivityIndicator.shared.hideLoadingIndicator()
                                        print("error is \(error.localizedDescription)")
                                        
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            // activityIndicators.stopAnimating()
                            //self.showToast(message: error.localizedDescription)
                            print(error.localizedDescription)
                        }
                    }
                }
    
    func sendCoupon3() {
        if let qr = UserDefaults.standard.string(forKey: "qr") {
            var qr_code = UserDefaults.standard.string(forKey: "survey") ?? ""
            if !Utility.isSurveyExist(surveyId: "Tier 3") {
                FirebaseUtility.sendQrCodeData(survey: "Tier 3", qr: qr, vc: self, surveyCode: qr_code)
                isSurvey3 = false
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
    
    func goToBeerCoupon() {
        let exampleVC = self.storyboard?.instantiateViewController(withIdentifier:"BeerCouponVC1") as! BeerCouponVC
        exampleVC.modalPresentationStyle = .overFullScreen
        exampleVC.modalTransitionStyle = .crossDissolve
        present(exampleVC, animated: true)
    }
    
}
