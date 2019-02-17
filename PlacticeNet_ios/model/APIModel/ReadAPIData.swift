//
//  ReadAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/24.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol SetMessageDelegate {
    func setMessageData(messageInfo: [ContentsInfoModel])
}

class ReadAPIData: GetAllType {
    
    var contents:[String] = []
    var idIndex:[Int] = []
    var setMessageDelegate: SetMessageDelegate?
    
    func getAllMessage() {
        
        if let req = SingletonURLRequest.getAllMessage() {
            
            URLSession.shared.dataTask(with: req) { (data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
                if let response = response as? HTTPURLResponse {
                    print("response.statusCode = \(response.statusCode)")
                }
                
                 let data = data
                let json = try? JSONDecoder().decode(ContentsInfoModel.self, from: data!)
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        let encoded = try? encoder.encode(json)
                        print(String(data: encoded!, encoding: .utf8)!)
                
                
               print("json:\(json)")
                
                DispatchQueue.main.async {
                    self.setMessageDelegate?.setMessageData(messageInfo: [json!])
                }
            }
            .resume()
        }
    }
}
