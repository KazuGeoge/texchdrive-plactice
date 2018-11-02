//
//  ContentsInfoModel.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/02.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

struct ContentsInfoModel: Codable {

    var contents: String?
    var id: Int?
    
    init(contents: String, id: Int) {
        self.contents = contents
        self.id = id
    }
}
