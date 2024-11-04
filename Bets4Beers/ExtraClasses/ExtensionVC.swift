//
//  ExtensionVC.swift
//  Bets4Beers
//
//  Created by Murteza on 08/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//


import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire

let btnUnderlineAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.boldSystemFont(ofSize: 14),
    .foregroundColor: UIColor.darkGray,
.underlineStyle: NSUnderlineStyle.single.rawValue]

extension UIViewController{
    
    
    
    // set Root View Controller
    func setRootVC(storyBoard:String){
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: storyBoard)
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    //Dispplay Dialog Box
    func ShowPopUp(stroyboard:String){
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:stroyboard )
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
    }
    
    func showDialog(message:String)
    {
        
        let alert = UIAlertController(title: "", message:message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1 //#d1a903
        subview.backgroundColor = UIColor.white
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
   
   
    
    //Next View Controller
    func NextViewController(storybordid:String)
    {
        let exampleVC  = self.storyboard?.instantiateViewController(withIdentifier:storybordid )
        exampleVC?.modalPresentationStyle = .overFullScreen
        exampleVC?.modalTransitionStyle = .crossDissolve
        present(exampleVC!, animated: true)
    }
    
    // Calculate Percntage
    func calculateTointPercentage(tpointpercentage:Double,tpointValue:Double)-> Double{
        // var result:Double = 0.0
        let tpointresult = (tpointValue * tpointpercentage)/100
        
        return tpointresult
        
    }
    func calculateCash(cashpercentage:Double,CashValue:Double)->Double{
        let cashResult = (cashpercentage * CashValue)/100
        
        return cashResult
    }
    
    //start animation
    
    func starAnimatingActivity(view:UIView ,indicator:UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            indicator.center = view.center
            
            
            indicator.style = UIActivityIndicatorView.Style.whiteLarge
            indicator.color = UIColor.blue
            view.addSubview(indicator)
            
            indicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
    }
    
  
    
    func setLoadingScreen(MainView:UIView,loadingView:UIView ,indicator:UIActivityIndicatorView,Message:String,loadingLabel:UILabel) {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (loadingView.frame.width / 2) - (width / 2)
        let y = (169 / 2) - (height / 2) + 60
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        loadingLabel.textColor = UIColor.white
        loadingLabel.textAlignment = NSTextAlignment.center
        loadingLabel.text = Message
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        loadingLabel.isHidden = false
        indicator.style = UIActivityIndicatorView.Style.whiteLarge
        indicator.color = UIColor.orange
        indicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        indicator.startAnimating()
        loadingView.addSubview(indicator)
        loadingView.addSubview(loadingLabel)
        MainView.addSubview(loadingView)
    }
    
    //Stop Animating
    func stopAnimation(indicator:UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
            indicator.isHidden = true
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
    ///custom Allert
    
    
    //Show Dialog
    func showDialog(message:String, controler:UIViewController)
    {
        
        let alert = UIAlertController(title: "", message:message, preferredStyle: .alert)
        controler.presentedViewController?.present(alert, animated: true, completion: nil)
        // cgetent(alert, true, nil)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1 //#d1a903
        subview.backgroundColor = UIColor.white
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    func showToast(message : String) {
        var height = 0
        if message.count >= 45 {
            height = 70
        } else {
            height = 40
        }
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: height))
        toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1.0)
        toastLabel.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minX + 165)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.minimumScaleFactor = 0.5
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = toastLabel.frame.height/2
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func alertMessageShow(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //Action Sheet
    func genderActionShaeet(textField:UITextField)
    {
        let actionSheet = UIAlertController(title: "Gender", message: "Select Your Gender", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Male", style: .default) { (action) in
            //Perform any actions specific to action 1 in your class
            textField.text = "Male"
        }
        let action2 = UIAlertAction(title: "Female", style: .default) { (action) in
            //Perform any actions specific to action 2 in your class
            textField.text = "Female"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil) //Will just dismiss the action sheet
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    // formatter.dateFormat = "dd.MM.yyyy hh:mm"
    
    func ConvertDateFormat(topdate:String) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date:Date = dateFormatter.date(from: topdate)!
        dateFormatter.dateFormat = "HH:mm dd-MM-yyy "
        return  dateFormatter.string(from: date)
    }
    
    func InActiveButton(button:UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.backgroundColor =  UIColor.clear.cgColor
        
        
        button.setTitleColor(UIColor(red: 24/256, green: 41/256, blue: 85/256, alpha: 1.0), for: .normal)
    }
    
    func ActiveButton(button:UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.backgroundColor =   UIColor(red: 24/256, green: 41/256, blue: 85/256, alpha: 1.0).cgColor
        /// button.titleLabel?.textColor = UIColor.white
        
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func ValidateFields(fields:[UITextField])->Bool{
        var flag:Bool = false
        for field in fields{
            if field.text == ""{
                flag = false
                Alert.showBasic(title: "Alert", message: "\(field.placeholder!) is required", vc: self)
                
                self.becomeFirstResponder()
            }else{
                flag = true
            }
            
        }
        return flag
    }
    
}

//Label Gradient Colour
class GradientLayer {
    
    let gradientLayer: CAGradientLayer
    let colorTop: CGColor
    let colorBottom: CGColor
    
    init(colorTop: UIColor, colorBottom: UIColor) {
        self.colorTop = colorTop.cgColor
        self.colorBottom = colorBottom.cgColor
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
    }
}

extension UILabel {
    func setTextColorToGradient(image: UIImage) {
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: bounds)
        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: myGradient!)
    }
}
extension UIView{
    func setViewToGradient(image: UIImage) {
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: bounds)
        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: myGradient!)
    }
    
    
    func dropShadowN() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
