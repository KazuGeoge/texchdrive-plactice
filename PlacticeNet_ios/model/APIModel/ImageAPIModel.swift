//
//  ImageAPIModel.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/04.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit



class ImageAPIModel: ImageType {

    var imageDelegate: ImageDelegate?
    
    func setImage(imageURL: String) {
        
        if let catPictureURL = URL(string: imageURL) {
            let req = URLRequest(url: catPictureURL)
            URLSession.shared.dataTask(with: req) { (data, responce, error) in
                
                if error != nil {
                    print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
                
                if let imageData = data {
                    if let imageimage = UIImage(data: imageData) {
                        
                        DispatchQueue.main.async {
                            self.imageDelegate?.getImage(image: imageimage)
                        }
                    }
                }
                }
                .resume()
        }
    }
}
