//
//  CreateAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/29.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol NewMessageDelegate {
    func setNewMessageData(content: ContentsInfoModel)
}

class CreateAPIData: CreateType {
    
    var newMessageDelegate: NewMessageDelegate?
    
    func createMessage(tweet: String) {
        
        let tweetDic:[String: String] = ["contents": tweet]
        
        if let req = SingletonURLRequest.createMessage(tweetContent: tweetDic) {
            
            SingletonURLRequest.dataTask(with: req) {(data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
                
                guard let data = data,
                    let jsonContentsInfoModelArray = try? JSONDecoder().decode(ContentsInfoModel.self, from: data) else {
                        return
                }
                
                DispatchQueue.main.sync {
                    // 返ってきたMessage情報をセット
                    self.newMessageDelegate?.setNewMessageData(content: jsonContentsInfoModelArray)
                }
            }
        }
    }
}
