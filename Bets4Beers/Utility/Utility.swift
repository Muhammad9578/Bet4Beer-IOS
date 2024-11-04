//
//  Utility.swift
//  Bets4Beers
//
//  Created by iOS Dev on 26/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import CoreImage

class Utility: NSObject {
    
    static func startLoader() {
        let activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", messageFont: UIFont.boldSystemFont(ofSize: 20), messageSpacing: 0.0, type: .ballSpinFadeLoader, color: #colorLiteral(red: 0.1176470588, green: 0.003921568627, blue: 0.6980392157, alpha: 1), padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: .none, textColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    static func stopLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    static func yearsBetweenDate(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: startDate, to: endDate)
        return components.year!
    }
    static func getDateFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: date)!
    }
    
   static func createQRFromString(str: String) -> CIImage? {
        let stringData = str.data(using: String.Encoding.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        return filter?.outputImage
    }
    
    static func isUserExist(uid: String) -> UserMO? {
        for user in SharedManager.shared.allUsers {
            if user.uid == uid {
                return user
            }
        }
        return nil
    }
    
   static func isSurveyExist(surveyId: String) -> Bool {
        let surveys = SharedManager.shared.surveys
        for single in surveys {
            if single.surveyName == surveyId {
                return true
            }
        }
        return false
    }
    
    static func getSurvey(surveyId: String) -> SurveyMO? {
        let surveys = SharedManager.shared.surveys
        for single in surveys {
            if single.surveyName == surveyId {
                return single
            }
        }
        return nil
    }
    
    static func getSurvey(code: String) -> SurveyMO? {
        let surveys = SharedManager.shared.surveys
        for single in surveys {
            if single.surveyCode == code {
                return single
            }
        }
        return nil
    }
}
