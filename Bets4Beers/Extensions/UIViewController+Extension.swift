//
//  UIViewController+Extension.swift
//  Bets4Beers
//
//  Created by iOS Dev on 01/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension UIViewController {
    func showMessageAlert(_ title: String, message: String, okHandler: ((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: okHandler)
        alertController.view.tintColor = #colorLiteral(red: 0.3539505005, green: 0.1115234122, blue: 0.507114172, alpha: 1)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showContinueAlert(_ title: String, message: String, continueHandler : (( UIAlertAction ) -> Void)?, cancelHandler : ((UIAlertAction) -> Void)?, continueTitle: String, cancelTitle: String, isCancel: Bool? = false) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: continueTitle, style: .default, handler: continueHandler)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler)
        let closeAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.view.tintColor = #colorLiteral(red: 0.3539505005, green: 0.1115234122, blue: 0.507114172, alpha: 1)
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        if isCancel ?? false {
            alertController.addAction(closeAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}
