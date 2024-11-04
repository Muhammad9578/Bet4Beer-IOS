//
//  SignupVC.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Alamofire

class SignupVC: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet var dobTF: UITextField!
    @IBOutlet var emailTermsBtn: UIButton!
    @IBOutlet var termsAndConditionsBtn: UIButton!
    @IBOutlet var referalIdTextField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var uploadProfile: UIButton!
    @IBOutlet var signupBtn: UIButton!
    
    var image: UIImage?
    var referalCode:String?
    var slected_comapign_name:String = ""
    var slected_voucher_Code:String = ""
    var slected_voucher_ID:String = ""
    var slected_voucher_Qr:String = ""
    var customer_source_id:String = ""
    var customer_name:String = ""
    var customer_email:String = ""
    var quantity:Int = 1
    var surveys = [SurveyMO]()
    let datePicker = UIDatePicker()
    var isMyCouponLoaded = false
    
    
    private var isValidated: Bool {
        guard let name = nameTF.text?.trim,
            let email = emailTF.text?.trim,
            let password = passwordTF.text?.trim,
            let retypePassword = confirmPasswordTF.text?.trim,
            let birthday = dobTF.text?.trim,
            let referal = referalIdTextField.text?.trim,
            let _ = self.image
            else {
                showMessageAlert(Strings.error, message: Strings.imageMiss)
                return false
        }
        var errorMessage: String?
        if name.isEmpty {
            errorMessage = Strings.nameRequired
        }
        else if email.isEmpty {
            errorMessage = Strings.emailRequired
        }
        else if !email.isValidEmail {
            errorMessage = Strings.emailInvalid
        }
        else if birthday.isEmpty {
            errorMessage = Strings.birthdayRequired
        }
        else if password.isEmpty {
            errorMessage = Strings.passwordRequired
        }
        else if retypePassword.isEmpty {
            errorMessage = Strings.retypePasswordRequired
        }
        else if password != retypePassword {
            errorMessage = Strings.passwordRetypeMatch
        }
        else if !checkInAge() {
            errorMessage = Strings.yourAgeLess
        }
        else if !termsAndConditionsBtn.isSelected {
            errorMessage = Strings.checkTerms
        }
        else if !referal.isEmpty {
            referalCode = referal
            if let _ = Utility.isUserExist(uid: referalCode ?? "") {
                print("ok")
            }else {
                errorMessage = Strings.referralCodeWrong
            }
        }else if SharedManager.shared.isUniqueIdExists {
            errorMessage = Strings.alreadySignup
        }
        
        if let errorMessage = errorMessage {
            showMessageAlert(Strings.error, message: errorMessage)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        UISetup()
        let attributeStringLogin = NSMutableAttributedString(string: "LOGIN",
                                                        attributes: btnUnderlineAttributes)
        loginBtn.setAttributedTitle(attributeStringLogin, for: .normal)
        let attributeStringUploadProfile = NSMutableAttributedString(string: "Upload Profile",
                                                        attributes: btnUnderlineAttributes)
        uploadProfile.setAttributedTitle(attributeStringUploadProfile, for: .normal)
        signupBtn.layer.cornerRadius = 3
    }
    
    //MARK:- Actions
    @IBAction func uploadProfileBtnClicked(_ sender: UIButton) {
        showSelectionSheet(imageOrVideo: "image")
    }
    
    @IBAction func receiveEmailCheckClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        emailTermsBtn.isSelected = sender.isSelected
    }
    @IBAction func termsConditionClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        termsAndConditionsBtn.isSelected = sender.isSelected
    }
    
    func checkInAge() -> Bool {
        if let dob = dobTF.text {
            let dateOfBirth = Utility.getDateFromString(date: dob)
            let currentDate = Date()
            let years = Utility.yearsBetweenDate(startDate: dateOfBirth, endDate: currentDate)
            if years >= 21 {
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        if isValidated {
            Utility.startLoader()
            guard let name = nameTF.text,
                let email = emailTF.text,
                let password = passwordTF.text,
                let dob = dobTF.text
                else {
                    return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
                if let result = dataResult {
                    let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
                    FirebaseUtility.uploadMedia(isProfile: true, image: self.image) { (imageUrl) in
                        if let imageUrl = imageUrl {
                            let data: NSDictionary = [
                                "email": email,
                                "userName": name,
                                "timeStamp": timeStamp,
                                "uid": result.user.uid,
                                "dob": dob,
                                "profileImage": imageUrl
                            ]
                            let ref: DatabaseReference?
                            ref = Database.database().reference()
                            let deviceId = SharedManager.shared.deviceUniqueId
                            let deviceData = ["\(deviceId)": "\(deviceId)"]
                            ref?.child(Strings.deviceIds).updateChildValues(deviceData)
                            
                            ref?.child(Strings.users).child(result.user.uid).setValue(data, withCompletionBlock: { (error, dataRef) in
                                if error == nil {
                                    if let referalCode = self.referalCode {
                                        if let user = Utility.isUserExist(uid: referalCode) {
                                            self.customer_name = user.userName ?? ""
                                            self.customer_email = user.email ?? ""
                                            self.slected_comapign_name = "Referral Code"
                                            self.postvoucherOrder()
                                        }
                                    }
                                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                        Utility.stopLoader()
                                        if let error = error {
                                            self.showMessageAlert(Strings.error, message: error.localizedDescription)
                                        }else {
                                            self.showMessageAlert(Strings.vefiryEmailTitle, message: Strings.pleaseVerifyEmail) { (_) in
                                                self.back()
                                            }
                                        }
                                    })
                                }else {
                                    Utility.stopLoader()
                                    self.showMessageAlert(Strings.appName, message: error?.localizedDescription ?? "")
                                }
                            })
                        }
                    }
                }else {
                    Utility.stopLoader()
                    self.showMessageAlert(Strings.appName, message: error?.localizedDescription ?? "")
                }
            }
            
        }
    }
    
    
    @IBAction func loginBtnClicked(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.present(vc, animated: true, completion: nil)
        back()
    }
    
    
    //MARK:- Functions
    func UISetup(){
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        showDatePicker()
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dobTF.inputAccessoryView = toolbar
        dobTF.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dobTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        back()
    }
    
}


extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicker.dismiss(animated: true, completion: nil)
            self.image = image
            profileImage.image = image
        }else {
            
        }
    }
}


extension SignupVC {
    
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
//        ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
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
//        ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
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
                        self.postcomapaignOrder()
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

extension SignupVC {
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
//             ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
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
//                 ActivityIndicator.shared.showLoadingIndicator(text: "wait.")
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
                            if let JSON = response.result.value {
                                print("JSON fee Result is : \(JSON)")
                                do {
                             ActivityIndicator.shared.hideLoadingIndicator()
                                 let res = JSON as! NSDictionary
                               print("result Publication is ---- \(res.object(forKey: "result") as? String ?? "")")
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
                                        self.sendCoupon3()
                                        
                                    }else {
                                        self.sendCoupon3()
                                        print("already created")
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
    
    func sendCoupon3() {
        if isMyCouponLoaded {
            if let qr = UserDefaults.standard.string(forKey: "qr") {
                let qr_code = UserDefaults.standard.string(forKey: "survey") ?? ""
                FirebaseUtility.sendQrCodeData(survey: "Referral Token", qr: qr, vc: self, surveyCode: qr_code)
                UserDefaults.standard.removeObject(forKey: "qr")
                UserDefaults.standard.removeObject(forKey: "survey")
            }
        }

        if !isMyCouponLoaded {
            if let user = Utility.isUserExist(uid: self.referalCode ?? "") {
                if let qr = UserDefaults.standard.string(forKey: "qr") {
                    let qr_code = UserDefaults.standard.string(forKey: "survey") ?? ""
                    FirebaseUtility.sendQrCodeDataUser(uid: user.uid ?? "", survey: "Referral Token", qr: qr, vc: self, surveyCode: qr_code)
                    UserDefaults.standard.removeObject(forKey: "qr")
                    UserDefaults.standard.removeObject(forKey: "survey")
                }
            }
            isMyCouponLoaded = true
            if let user = Utility.isUserExist(uid: Auth.auth().currentUser?.uid ?? "") {
                self.customer_name = user.userName ?? ""
                self.customer_email = user.email ?? ""
                self.slected_comapign_name = "Referral Code"
                self.postvoucherOrder()
            }
        }
    }
    
    
    // --------------- Date Externsion ------------------- //
    func gettodayDate() -> String {
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
