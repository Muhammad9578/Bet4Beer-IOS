//
//  ActivityIndicator.swift
//  Bets4Beers
//
//  Created by Murteza on 08/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ActivityIndicator: NSObject {


fileprivate static let overlayView: UIView = UIView()
var timer: Timer?
// fileprivate static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
fileprivate static let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60) , type: .ballClipRotatePulse, color: .systemPink, padding: 10)
fileprivate static let label = UILabel(frame: CGRect(x: 0, y: 20, width: 200, height: 21))
class var shared : ActivityIndicator{
struct Static {
static let instance = ActivityIndicator()
}
return Static.instance
}

fileprivate override init() {
super.init()
ActivityIndicator.overlayView.backgroundColor = appcolor.withAlphaComponent(0.3)
}

func showLoadingIndicator(text: String?, type: NVActivityIndicatorType = .circleStrokeSpin, color: UIColor = appcolor) {

ActivityIndicator.label.center = CGPoint(x: 160, y: 285)
ActivityIndicator.label.textAlignment = .center
ActivityIndicator.label.textColor = color
ActivityIndicator.label.font = UIFont.boldSystemFont(ofSize: 16)
ActivityIndicator.label.text = text
//
UIApplication.shared.beginIgnoringInteractionEvents()
guard let window : UIWindow = (UIApplication.shared.keyWindow) else { return }
ActivityIndicator.overlayView.frame = window.frame
ActivityIndicator.activityIndicator.center = window.center
ActivityIndicator.activityIndicator.color = color
ActivityIndicator.activityIndicator.type = type
ActivityIndicator.activityIndicator.startAnimating()
ActivityIndicator.overlayView.addSubview(ActivityIndicator.activityIndicator)
window.addSubview(ActivityIndicator.overlayView)
window.addSubview(ActivityIndicator.label)
window.bringSubviewToFront(ActivityIndicator.overlayView)
window.bringSubviewToFront(ActivityIndicator.label)
//
ActivityIndicator.label.translatesAutoresizingMaskIntoConstraints = false
ActivityIndicator.label.centerYAnchor.constraint(equalTo: ActivityIndicator.overlayView.centerYAnchor, constant: 40).isActive = true
ActivityIndicator.label.centerXAnchor.constraint(equalTo: ActivityIndicator.overlayView.centerXAnchor, constant: 0).isActive = true
if let text = text {
ActivityIndicator.label.text = "\(text) ."

timer = Timer.scheduledTimer(withTimeInterval: 0.55, repeats: true) { (timer) in
var string: String {
switch ActivityIndicator.label.text {
case "\(text) .": return "\(text) .."
case "\(text) ..": return "\(text) ..."
case "\(text) ...": return "\(text) ."
default: return "\(text)"
}
}
ActivityIndicator.label.text = string
}

}
}

func hideLoadingIndicator() {
UIApplication.shared.endIgnoringInteractionEvents()
ActivityIndicator.activityIndicator.stopAnimating()
ActivityIndicator.overlayView.removeFromSuperview()
ActivityIndicator.label.removeFromSuperview()
timer?.invalidate()
}
}
