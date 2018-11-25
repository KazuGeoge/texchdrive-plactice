//
//  ImagePickerView.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/12.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol TakingImageType {
    func takeImage(image: UIImage)
}

protocol ToTweetViewImage {
    func setSelectedImage(image: UIImage)
}

class ImagePickerView: NSObject {

    var takingImageType: TakingImageType?
    private var isTextEditView: Bool?
    var toTweetViewImage: ToTweetViewImage?
    
    func startUpCamera(isFromTextEditView: Bool) -> UIImagePickerController? {
        // カメラが利用可能か?
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            isTextEditView = isFromTextEditView
            return cameraPicker
        }
        return nil
    }
    
    func openCameraRoll(isFromTextEditView: Bool) -> UIImagePickerController? {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            isTextEditView = isFromTextEditView
            
            return pickerView
        }
        return nil
    }
}

// UIImagePickerControllerDelegate
extension ImagePickerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // 選択した写真を取得する
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if isTextEditView == true {
                takingImageType?.takeImage(image: image)
            } else {
                toTweetViewImage?.setSelectedImage(image: image)
            }
        }
    }
}
