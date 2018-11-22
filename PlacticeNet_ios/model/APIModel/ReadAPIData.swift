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
    
    var setMessageDelegate: SetMessageDelegate?
    
    func getAllMessage() {
        
        if let req = SingletonURLRequest.getAllMessage() {
            
            SingletonURLRequest.dataTask(with: req) {(data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
                
                guard let data = data,
                    let json = try? JSONDecoder().decode([ContentsInfoModel].self, from: data) else {
                        return
                }
                
                DispatchQueue.main.async {
                    self.setMessageDelegate?.setMessageData(messageInfo: json)
                }
            }
        }
    }
}
