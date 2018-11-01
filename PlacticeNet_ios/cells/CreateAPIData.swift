//
//  CreateAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/29.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol NewMessageDelegate {
    func setNewMessageData(content: String, textID: Int)
}

class CreateAPIData: CreateType {
    
    var contents:[String] = []
    var idIndex:[Int] = []
    var newMessageDelegate: NewMessageDelegate?
    
    func createMessage(tweet: String) {
        
        let tweetDic:[String: String] = ["contents": tweet]
        SingletonURLRequest.createMessage()
        SingletonURLRequest.req.httpBody = try? JSONSerialization.data(withJSONObject: tweetDic)
        // TODO: 以下他クラスとまとめられないか
        URLSession.shared.dataTask(with: SingletonURLRequest.req) { (data, responce, error) in
            
            if error != nil {
                print(error!.localizedDescription) // nil無しの条件のため!を許容
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data),
                let repos = json as? [String: Any] else {
                    return
            }
            
            DispatchQueue.main.sync {
                // 返ってきたContentsとIDをセット
                self.newMessageDelegate?.setNewMessageData(content: repos["contents"] as? String ?? "", textID: repos["id"] as? Int ?? 9999)
                }
            }
            .resume()
    }
}
