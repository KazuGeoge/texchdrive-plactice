//
//  ContentsInfoModel.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/02.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit
import Kingfisher

//struct ContentsInfoModel: Codable {
//var contents: String
//var id: Int
//var url: String
//var user_id: Int?
//}

struct ContentsInfoModel: Codable {
<<<<<<< HEAD
    var contents: String
    var id: Int
    var url: String?
    var image: UIImage?
    var user_id: Int?

    private enum CodingKeys: String, CodingKey {
        case contents
        case id
        case url
        case user_id
        case image
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contents = try values.decode(String.self, forKey: .contents)
        id = try values.decode(Int.self, forKey: .id)
        user_id = try values.decode(Int.self, forKey: .user_id)
        let imageData = try values.decode(String.self, forKey: .url)
//        url = try values.decode(String.self, forKey: .urlString)
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: imageData ), placeholder: UIImage(named: "noImage"), completionHandler: nil)
        image = imageView.image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contents, forKey: .contents)
        try container.encode(id.description, forKey: .id)
        try container.encode(user_id!.description, forKey: .user_id)
        try container.encode(image!.description, forKey: .image)
        try container.encode(url!.description, forKey: .url)
    }
=======

    var contents: String?
    var id: Int?
    var url: String?
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
}
