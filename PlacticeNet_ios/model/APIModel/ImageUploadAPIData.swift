//
//  ImageUploadAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/05.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class ImageUploadAPIData: UploadImageType {

    func setImage(textid: Int, image: UIImage) {
        // 通信のリクエスト生成.
        if let req = SingletonURLRequest.uploadImage(textID: textid,  image: image) {
        URLSession.shared.dataTask(with: req) { (data, responce, error) in
            
            if error != nil {
                print(error!.localizedDescription) // nil無しの条件のため!を許容
            }
        }
            // タスクの実行.
            .resume()
        }
    }
}
