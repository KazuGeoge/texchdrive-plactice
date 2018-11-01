//
//  UPLoadAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/29.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class UPLoadAPIData: UpLoadType{
    
    func putMessage(tweet: String, textID: Int) {
        
        let tweetDic:[String: String] = ["contents": tweet]
        SingletonURLRequest.upLoadMessage(textID: textID)
        SingletonURLRequest.req.httpBody = try? JSONSerialization.data(withJSONObject: tweetDic)
        // TODO: 以下他クラスとまとめられないか
        URLSession.shared.dataTask(with: SingletonURLRequest.req) { (data, responce, error) in
            
            if error != nil {
                print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
            }
            .resume()
    }
}
