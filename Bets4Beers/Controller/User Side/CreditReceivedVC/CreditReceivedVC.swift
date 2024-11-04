//
//  CreditReceivedVC.swift
//  Bets4Beers
//
//  Created by apple on 4/9/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CreditReceivedVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    var surveys = [SurveyMO]()
    var surveysRemainings = [SurveyMO]()
    var orderNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Token Received"
        loadMySurveys()
        NotificationCenter.default.addObserver(self, selector: #selector(loadMySurveys), name: .loadMySurveys, object: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadMySurveys() {
        surveys = SharedManager.shared.surveys
        let sorted = surveys.sorted { (survey1, survey2) -> Bool in
            return (survey1.timeStamp ?? 0) < (survey2.timeStamp ?? 0)
        }
        surveys = sorted
        for survey in surveys {
            if survey.surveyName == "Tier 1" {
                survey.orderNo = self.orderNo
                survey.quantity = 1
            }else if survey.surveyName == "Tier 2" {
                self.orderNo = self.orderNo + 1
                survey.orderNo = self.orderNo
                survey.quantity = 3
            }else {
                self.orderNo = self.orderNo + 1
                survey.orderNo = self.orderNo + 1
            }
            let ss = SharedManager.shared.screenShot
            if survey.surveyName == "Tier 3" {
                if ss?.status == "approved" {
                    survey.quantity = 10
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
        tableView.reloadData()
    }
    

}

extension CreditReceivedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveysRemainings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditReceivedTBViewCell", for: indexPath) as! CreditReceivedTBViewCell
        cell.survey = surveysRemainings[indexPath.row]
        return cell
    }
    
}
