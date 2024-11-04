//
//  BaseViewController.swift
//  Bets4Beers
//
//  Created by iOS Dev on 26/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import MobileCoreServices

class BaseViewController: UIViewController {

    var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func back() {
//        self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController {
    func showSelectionSheet(imageOrVideo : String) {
        let alert = UIAlertController(title: "", message: "Upload Attachment", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose from gallery", style: .default , handler:{ (UIAlertAction) in
            self.pickPhoto(imageOrVideo: imageOrVideo, sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler:{ (UIAlertAction) in
            self.pickPhoto(imageOrVideo: imageOrVideo, sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    private func pickPhoto(imageOrVideo: String,sourceType: UIImagePickerController.SourceType) {
        switch sourceType {
        case .camera:
            imagePicker.sourceType = sourceType
            imagePicker.modalPresentationStyle = .fullScreen
            if imageOrVideo == "image" {
                imagePicker.mediaTypes = [(kUTTypeImage as String)]
                imagePicker.cameraCaptureMode = .photo
            }else if imageOrVideo == "video" {
                imagePicker.mediaTypes = [(kUTTypeMovie as String)]
                imagePicker.cameraCaptureMode = .video
            }
            
        case .photoLibrary:
            imagePicker.sourceType = sourceType
            if imageOrVideo == "image" {
                imagePicker.mediaTypes = [(kUTTypeImage as String)]
            }else if imageOrVideo == "video" {
                imagePicker.mediaTypes = [(kUTTypeMovie as String)]
            }
            
        default: break
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

