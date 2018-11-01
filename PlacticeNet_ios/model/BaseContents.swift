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
    
    var contents: String
    var token: String
    
    init(contents: String, token: String) {
        self.contents = contents
        self.token = token
    }
}
