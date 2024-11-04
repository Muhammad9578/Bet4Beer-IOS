//
//  BeerCouponVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class BeerCouponVC: UIViewController, SMFeedbackDelegate {
    
    
    @IBOutlet var tierView: ShadowView!
    @IBOutlet var tier3View: ShadowView!
    @IBOutlet var tier2View: ShadowView!
    @IBOutlet weak var qrImage: UIImageView!
    var  qr_url = ""
    var surveyMonkeyfeedback2:SMFeedbackViewController?
    
    var slected_comapign_name:String = ""
    var slected_voucher_Code:String = ""
    var slected_voucher_ID:String = ""
    var slected_voucher_Qr:String = ""
    var customer_source_id:String = ""
    var customer_name:String = ""
    var customer_email:String = ""
    var quantity:Int = 1
    var qr_code: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.surveyMonkeyfeedback2 = SMFeedbackViewController(survey: "ZFWXRTM")
        self.surveyMonkeyfeedback2?.delegate = self
        // Do any additional setup after loading the view.
        qr_url = UserDefaults.standard.string(forKey: "qr") ?? ""
        qr_code = UserDefaults.standard.string(forKey: "survey") ?? ""
        self.qrImage.sd_setImage(with: URL(string: qr_url.replacingOccurrences(of: " ", with: "%20") ), placeholderImage: UIImage(named: "QRCode"))
        if !Utility.isSurveyExist(surveyId: "Tier 1") {
            FirebaseUtility.sendQrCodeData(survey: "Tier 1", qr: qr_url, vc: self, surveyCode: qr_code)
        }
        else if self.restorationIdentifier == "BeerCouponVC1" {
            if !Utility.isSurveyExist(surveyId: "Tier 2") {
                FirebaseUtility.sendQrCodeData(survey: "Tier 2", qr: qr_url, vc: self, surveyCode: qr_code)
            }
        }
        if self.restorationIdentifier == "BeerC3" {
            
        }else {
            if self.restorationIdentifier == "BeerCouponVC1" {
                let ss = SharedManager.shared.screenShot
                if Utility.isSurveyExist(surveyId: "Tier 3") {
                    if ss?.status == "approved" {
                        tierView.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2, blue: 0.5333333333, alpha: 1)
                    }else {
                        tierView.backgroundColor = #colorLiteral(red: 0.02348791435, green: 0.6567551494, blue: 1, alpha: 1)
                    }
                }else {
                    tierView.backgroundColor = #colorLiteral(red: 0.02348791435, green: 0.6567551494, blue: 1, alpha: 1)
                }
            }else {
                if !Utility.isSurveyExist(surveyId: "Tier 2") {
                    tierView.backgroundColor = #colorLiteral(red: 0.02348791435, green: 0.6567551494, blue: 1, alpha: 1)
                }else {
                    tierView.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2, blue: 0.5333333333, alpha: 1)
                }
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
    @IBAction func survey2No(_ sender: Any) {
        if !Utility.isSurveyExist(surveyId: "Tier 1") {
            FirebaseUtility.sendQrCodeData(survey: "Tier 1", qr: qr_url, vc: self, surveyCode: qr_code)
        }
        self.setRootVC(storyBoard: "SelectSurveyVC")
    }
    @IBAction func survey3No(_ sender: Any) {
        if !Utility.isSurveyExist(surveyId: "Tier 2") {
            FirebaseUtility.sendQrCodeData(survey: "Tier 2", qr: qr_url, vc: self, surveyCode: qr_code)
        }
        self.setRootVC(storyBoard: "SelectSurveyVC")
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "SidemenuVC") as! SidemenuVC
            vc.isSideMenu = true
            self.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @IBAction func sevey2Btn(_ sender: Any) {
        if Utility.isSurveyExist(surveyId: "Tier 2") {
            if let survey2 = Utility.getSurvey(surveyId: "Tier 2")
            {
                UserDefaults.standard.set(survey2.qrCode, forKey: "qr")
            }
            self.NextViewController(storybordid: "BeerCouponVC1")
        }else {
            FirebaseUtility.sendQrCodeData(survey: "Tier 1", qr: qr_url, vc: self, surveyCode: qr_code)
            quantity = 3
            customer_name =  "servey 2 Customer"
            customer_email = "servey2@gmail.com"
            slected_comapign_name = "survey two Comapaign"
            self.postvoucherOrder()
            nowFrom = "servey2"
        }
    }
    @IBAction func servy2completBtn(_ sender: Any) {
        let ss = SharedManager.shared.screenShot
        if ss?.status == "Pending" {
            self.NextViewController(storybordid: "ThanksSSVCViewController")
        }
        else if ss?.status == "approved"{
            if let survey3 = Utility.getSurvey(surveyId: "Tier 3")
            {
                UserDefaults.standard.set(survey3.qrCode, forKey: "qr")
            }
            self.NextViewController(storybordid: "BeerC3")
        }else {
            FirebaseUtility.sendQrCodeData(survey: "Tier 2", qr: qr_url, vc: self, surveyCode: qr_code)
            nowFrom = "servey3"
            self.NextViewController(storybordid: "BeerCouponVC3")
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.setRootVC(storyBoard: "SelectSurveyVC")
    }
    
    
}


extension BeerCouponVC {
    
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
//                        if nowFrom == "s1complete"{
//                            self.surveyMonkeyfeedback2?.present(from: self, animated: true, completion: nil)
//
//                            //                                    self.surveyMonkeyfeedback2?.navigationController?.pushViewController(self, animated: true)
//                        }else {
//
//                        }
                        if nowFrom == "servey2"{
                            self.surveyMonkeyfeedback2?.navigationController?.pushViewController(self, animated: true)
                            self.surveyMonkeyfeedback2?.present(from: self, animated: true, completion: nil)
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
}
