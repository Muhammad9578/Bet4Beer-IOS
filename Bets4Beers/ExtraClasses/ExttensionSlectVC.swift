//
//  ExttensionSlectVC.swift
//  Bets4Beers
//
//  Created by Murteza on 08/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire
import NVActivityIndicatorView


extension BeerCouponVC {
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
             
             func createPublicationParams()->PblicationPostMdel{
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
                               print("result Publication is ---- \(res.object(forKey: "result") as! String)")
                                let result =  res.object(forKey: "result") as! String
                                    
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
                                        if nowFrom == "servey2"{
                                            self.NextViewController(storybordid: "BeerCouponVC1")

                                        }else{
                                        self.NextViewController(storybordid: "BeerCouponVC")
                                        }
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



extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
