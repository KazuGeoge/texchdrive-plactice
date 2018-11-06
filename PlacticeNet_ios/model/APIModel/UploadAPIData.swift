//
//  UPLoadAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/29.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class UploadAPIData: UploadType{
    
    func putMessage(tweet: String, textid: Int) {
        
        if let req =  SingletonURLRequest.uploadMessage(textID: textid, editedContent: tweet) {
       
        URLSession.shared.dataTask(with: req) { (data, responce, error) in
          
            if error != nil {
                print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
            }
            .resume()
        }
    }
}
