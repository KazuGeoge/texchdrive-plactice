//
//  DeleteAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/29.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class DeleteAPIData: DeleteType {
    
    var getAllType: GetAllType?
    
    func deleteMessage(textId: Int) {
        
        if let req = SingletonURLRequest.deleteMessage(textId: textId) {
            
            SingletonURLRequest.dataTask(with: req) {(data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
                self.getAllType?.getAllMessage()
            }
        }
    }
}
