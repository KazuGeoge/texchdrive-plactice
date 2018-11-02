//
//  BaseContents.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/24.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

// TO DO Jsonの受け取りをCodableで出来ないか
class BaseContents: Codable {
    
    var token: String
    
    init(token: String) {
        self.token = token
    }
}
