//
//  FirebaseUtility.swift
//  Bets4Beers
//
//  Created by iOS Dev on 04/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FirebaseUtility: NSObject {
    
    static func getMyData() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.users).queryOrdered(byChild: "uid").queryEqual(toValue: Auth.auth().currentUser?.uid ?? "").observe(.value, with: { (snapShot) in
            if let value = snapShot.value
            {
                let data = value as? NSDictionary ?? [:]
                let user = UserMO(with: data.allValues.first
                    as? [String : Any] ?? [:])
                SharedManager.shared.user = user
                NotificationCenter.default.post(name: .loadMyData, object: nil)
            }else {
                SharedManager.shared.user = nil
                NotificationCenter.default.post(name: .loadMyData, object: nil)
            }
        })
    }
    
    static func getAllUsers() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.users).observe(.value, with: { (snapShot) in
            var allUsers = [UserMO]()
            let value = snapShot.value as? NSDictionary
            if value != nil {
                for (userKey, userVal) in value ?? [:] {
                    let user = UserMO(with: userVal as? [String : Any] ?? [:])
                    user?.uid = userKey as? String ?? ""
                    if let user = user {
                        allUsers.append(user)
                    }
                }
                SharedManager.shared.allUsers = allUsers
                NotificationCenter.default.post(name: .loadMySurveys, object: nil)
            }else {
                SharedManager.shared.allUsers = allUsers
                NotificationCenter.default.post(name: .loadMySurveys, object: nil)
            }
        })
    }
    
    static func checkDeviceId() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        let deviceId = SharedManager.shared.deviceUniqueId
        ref?.child(Strings.deviceIds).observe(.value, with: { (snapShot) in
            let value = snapShot.value as? NSDictionary ?? [:]
            var allDevices = [String]()
            if value.count != 0 {
                for (id,_) in value {
                    allDevices.append(id as? String ?? "")
                }
                if allDevices.contains(deviceId) {
                    SharedManager.shared.isUniqueIdExists = true
                }else {
                    SharedManager.shared.isUniqueIdExists = false
                }
            }else {
                SharedManager.shared.isUniqueIdExists = false
            }
        })
    }
    
    static func getAllSurveys() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.serveys).child(Auth.auth().currentUser?.uid ?? "").observe(.value, with: { (snapShot) in
            var surveys = [SurveyMO]()
            let value = snapShot.value as? NSDictionary
            if value != nil {
                for (surveyKey, surveyVal) in value ?? [:] {
                    let survey = SurveyMO(with: surveyVal as? [String : Any] ?? [:])
                    survey?.surveyId = surveyKey as? String ?? ""
                    if let survey = survey {
                        surveys.append(survey)
                    }
                }
                SharedManager.shared.surveys = surveys
                isSurveyLoaded = true
                NotificationCenter.default.post(name: .loadMySurveys, object: nil)
            }else {
                SharedManager.shared.surveys = surveys
                isSurveyLoaded = true
                NotificationCenter.default.post(name: .loadMySurveys, object: nil)
            }
        })
    }
    
    static func getScreenShot() {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        ref?.child(Strings.screenShots).queryOrdered(byChild: "uid").queryEqual(toValue: Auth.auth().currentUser?.uid ?? "").observe(.value, with: { (snapShot) in
            var screenShot = SharedManager.shared.screenShot
            let value = snapShot.value as? NSDictionary
            if value != nil {
                for (_,val) in value ?? [:] {
                    let ss = ScreenShotMO(with: val as? [String : Any] ?? [:])
                    screenShot = ss
                    SharedManager.shared.screenShot = screenShot
                    NotificationCenter.default.post(name: .loadSS, object: nil)
                }
            }else {
                screenShot = ScreenShotMO(with: [:])
                SharedManager.shared.screenShot = screenShot
                NotificationCenter.default.post(name: .loadSS, object: nil)
            }
        })
    }
    
    static func uploadMedia(isProfile: Bool, image: UIImage?, completion: @escaping (_ url: String?) -> Void) {
        var storageRef: StorageReference?
        if isProfile {
            storageRef = Storage.storage().reference().child("ProfileImages").child("\(Auth.auth().currentUser?.uid ?? "")-profile.png")
        }else {
            storageRef = Storage.storage().reference().child("Screenshots").child("\(Auth.auth().currentUser?.uid ?? "")-SS.png")
        }
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if let uploadData = image?.jpegData(compressionQuality: 0.01) {
            storageRef?.putData(uploadData, metadata: metadata) { (storageData, error) in
                storageRef?.downloadURL(completion: { (url, error) in
                    completion(url?.absoluteString)
                })
            }
        }
    }
    
    static func sendQrCodeData(survey: String,qr: String?,vc: UIViewController, surveyCode: String) {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        var isSurveyExist = false
        
        switch survey {
        case "Tier 1":
            isSurveyExist = Utility.isSurveyExist(surveyId: "Tier 1")
        case "Tier 2":
            isSurveyExist = Utility.isSurveyExist(surveyId: "Tier 2")
        case "Tier 3":
            isSurveyExist = Utility.isSurveyExist(surveyId: "Tier 3")
        default:
            return
        }
        if !isSurveyExist {
            let data: [String:Any] = [
                "timeStamp": timeStamp,
                "surveyName": survey,
                "qrCode": qr ?? "",
                "surveyCode": surveyCode
            ]
            ref?.child(Strings.serveys).child("\(Auth.auth().currentUser?.uid ?? "")").childByAutoId().setValue(data, withCompletionBlock: { (error, dataRef) in
                if error == nil {
                    print("ok")
                }else {
                    vc.showMessageAlert(Strings.appName, message: error?.localizedDescription ?? "")
                }
            })
        }
    }
    
    static func sendQrCodeDataUser(uid: String,survey: String,qr: String?,vc: UIViewController, surveyCode: String) {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        let data: [String:Any] = [
            "timeStamp": timeStamp,
            "surveyName": survey,
            "qrCode": qr ?? "",
            "surveyCode": surveyCode
            ]
        ref?.child(Strings.serveys).child("\(uid)").childByAutoId().setValue(data, withCompletionBlock: { (error, dataRef) in
            if error == nil {
                print("ok")
            }else {
                vc.showMessageAlert(Strings.appName, message: error?.localizedDescription ?? "")
            }
        })
    }
}

