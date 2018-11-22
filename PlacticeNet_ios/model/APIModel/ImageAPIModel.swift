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
            if let imageString = contentInfo.url {
                
                if let catPictureURL = URL(string: imageString) {
                    
                    let req = URLRequest(url: catPictureURL)
                    SingletonURLRequest.dataTask(with: req) {(data, response, error) in
                        
                        if error != nil {
                            print(error!.localizedDescription) // nil無しの条件のため!を許容
                        }
                        
                        // サブスレッドで非同期で通信をする
                        DispatchQueue.global().async {
                            if let imageData = data {
                                self.image = UIImage(data: imageData)
                            }
                            
                            // データが帰ってきたらメインスレッドで描画をする
                            DispatchQueue.main.sync {
                                if let messageId = contentInfo.id {
                                    // 画像ではないURLだったらでか画像がない事を示す画像をセットする
                                    if let noImage = UIImage(named: "noImage") {
                                        self.imageDelegate?.getImage(image: self.image ?? noImage, messageId: messageId)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
