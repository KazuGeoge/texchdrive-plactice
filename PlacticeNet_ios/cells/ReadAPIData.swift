//
//  ReadAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/24.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol SetMessageDelegate {
    func setMessageData(content: [String], id: [Int])
}

class ReadAPIData: GetAllType {
    
    var contents:[String] = []
    var idIndex:[Int] = []
    var setMessageDelegate: SetMessageDelegate?
    
    func getAllMessage() {
        
        SingletonURLRequest.getAllMessage()
       // TODO: 以下他クラスとまとめられないか
        URLSession.shared.dataTask(with: SingletonURLRequest.req) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription) // nil無しの条件のため!を許容
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data),
                let jsonArray = json as? Array<Any> else {
                    return
            }
            
            self.contents = []
            self.idIndex = []
            
            // 各ContentsといIDを配列に格納
            for json in jsonArray {
                let jsonDic = json as? NSDictionary
                self.contents.append(jsonDic?["contents"] as? String ?? "")
                // TODO: Intの場合何を入れたらいいか
                self.idIndex.append(jsonDic?["id"] as? Int ?? 99999)
            }
            
            DispatchQueue.main.async {
                self.setMessageDelegate?.setMessageData(content: self.contents, id: self.idIndex)
                }
            }
            .resume()
    }
}
