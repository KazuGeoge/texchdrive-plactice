//
//  ImageAPIModel.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/04.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol ImageDelegate {
    func getImage(image: UIImage, messageId: Int)
}

class ImageAPIModel: ImageWithMessageIdType {
    
    private var image: UIImage?
    private var ImagesArray: [UIImage] = []
    var imageDelegate: ImageDelegate?
    
    func setImage(messageInfo: [ContentsInfoModel]) {
        
        for contentInfo in messageInfo {
            // 画像のURLの場合はリクエストを送り、帰ってきたら画像をセット
                
            if let catPictureURL = URL(string: "") {
                    
                let req = URLRequest(url: catPictureURL)
                SingletonURLRequest.dataTask(with: req) {(data, response, error) in
                        
                    if error != nil {
                        print(error!.localizedDescription) // nil無しの条件のため!を許容
                    }
                        
                    // サブスレッドで非同期で通信をする
                    DispatchQueue.global().async {
                        var image = UIImage(named: "")
                        if let imageData = data {
                            image = UIImage(data: imageData)
                        }
                            
                        // データが帰ってきたらメインスレッドで描画をする
                        DispatchQueue.main.sync {
                            // 画像ではないURLだったらでか画像がない事を示す画像をセットする
                            if let noImage = UIImage(named: "noImage") {
                                self.imageDelegate?.getImage(image: image ?? noImage, messageId: contentInfo.id)
                            }
                        }
                    }
                }
            }
        }
    }
}
