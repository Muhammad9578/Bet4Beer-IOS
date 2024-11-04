//
//  SharedManager.swift
//  Bets4Beers
//
//  Created by iOS Dev on 04/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class SharedManager {
    // Singleton
    static var shared = SharedManager()
    private var defaults = UserDefaults.standard
    
    private init() {
        setup()
    }
    
    var user: UserMO? {
        didSet {
            syncUser()
        }
    }
    var surveys = [SurveyMO]()
    var screenShot: ScreenShotMO?
    var allUsers = [UserMO]()
    var deviceUniqueId = ""
    var isUniqueIdExists = false
    var isDataLoaded = false
    
    var isLoggedIn: Bool { return user != nil }
    
    func syncUser() {
        guard let user = user,
            let string = user.json
            else {
                defaults.removeObject(forKey: UserDefaultKeys.loggedInUser)
                return
        }
        defaults.set(string, forKey: UserDefaultKeys.loggedInUser)
    }
    
    private func setup() {
        if let userString = defaults.string(forKey: UserDefaultKeys.loggedInUser),
            let user = UserMO(jsonString: userString) {
            self.user = user
        }
    }
}
