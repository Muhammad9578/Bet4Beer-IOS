//
//  CreditRemainingVC.swift
//  Bets4Beers
//
//  Created by apple on 4/9/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire

class CreditRemainingVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var surveysRemainings = [SurveyMO]()
    var orderNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Remaining Tokens"
        callApiForCredit()
    }
    
    func callApiForCredit() {
        self.surveysRemainings = []
        for single in SharedManager.shared.surveys {
            Utility.startLoader()
            callApi(promo: single.surveyCode ?? "") { (survey) in
                if survey.surveyName == "Tier 1" {
                    survey.orderNo = self.orderNo
                }else if survey.surveyName == "Tier 2" {
                    self.orderNo = self.orderNo + 1
                    survey.orderNo = self.orderNo
                }else {
                    self.orderNo = self.orderNo + 1
                    survey.orderNo = self.orderNo + 1
                }
                let ss = SharedManager.shared.screenShot
                if survey.surveyName == "Tier 3" {
                    if ss?.status == "approved" {
                        self.surveysRemainings.append(survey)
                        if (self.surveysRemainings.count == SharedManager.shared.surveys.count) || (self.surveysRemainings.count == SharedManager.shared.surveys.count - 1){
                            Utility.stopLoader()
                            let sorted = self.surveysRemainings.sorted { (survey1, survey2) -> Bool in
                                return (survey1.orderNo ?? 0) < (survey2.orderNo ?? 0)
                            }
                            self.surveysRemainings = sorted
                            self.tableView.reloadData()
                        }
                    }
                }else {
                    self.surveysRemainings.append(survey)
                    if (self.surveysRemainings.count == SharedManager.shared.surveys.count) || (self.surveysRemainings.count == SharedManager.shared.surveys.count - 1) {
                        let sorted = self.surveysRemainings.sorted { (survey1, survey2) -> Bool in
                            return (survey1.orderNo ?? 0) < (survey2.orderNo ?? 0)
                        }
                        self.surveysRemainings = sorted
                        Utility.stopLoader()
                        self.tableView.reloadData()
                    }
                }

            }
        }
    }
    @IBAction func btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func callApi(promo: String, completion: @escaping (SurveyMO) -> Void) {
        var request = URLRequest(url: URL(string: "https://us1.api.voucherify.io/v1/vouchers/\(promo)")!)
        request.setValue("2986fb82-6dae-4e5b-a070-ec57e8849b84", forHTTPHeaderField: "X-App-Id")
         request.setValue("90bf01af-4ac2-4d0e-970d-04ff3a639bfb", forHTTPHeaderField: "X-App-Token")
        
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         request.httpMethod = "GET"
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
                        let code = res["code"]
                        print("code //: \(code ?? "")")
                        if let survey = Utility.getSurvey(code: code as? String ?? "") {
                            let redemption = res["redemption"] as? NSDictionary ?? [:]
                            survey.quantity = redemption["quantity"] as? Int ?? 0
                            survey.redemmedQuantity = redemption["redeemed_quantity"] as? Int ?? 0
                            completion(survey)
                        }
                    } catch let error {
                        Utility.stopLoader()
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

extension CreditRemainingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveysRemainings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditRemainingTBViewCell", for: indexPath) as! CreditRemainingTBViewCell
        cell.survey = surveysRemainings[indexPath.row]
        return cell
    }
    
}
