//
//  ImageUploadAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/05.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class ImageUploadAPIData: UploadImageType {
    
    func setImage(textId: Int, image: UIImage?) {
        
        if let uploadImage = image {
            if let req =  SingletonURLRequest.uploadImage(image: uploadImage, textId: textId) {
                
                SingletonURLRequest.dataTask(with: req) {(data, response, error) in
                    
                    if error != nil {
                        print(error!.localizedDescription) // nil無しの条件のため!を許容
                    }
                }
            }
        }
    }
}
