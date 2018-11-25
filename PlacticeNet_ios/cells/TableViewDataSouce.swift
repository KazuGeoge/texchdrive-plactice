//
//  TableViewDataSouce.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class TableViewDataSouce: NSObject, UITableViewDataSource, UITableViewDelegate{

    let sectionTitle = ["ツイート"]
    var contentsInfoModel: [ContentsInfoModel] = []
    var tweetViewController: CellsIdType?
    var resistedImage: UIImage?
    var fixNumber: Int?
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // セクションの内容
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    // cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsInfoModel.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TweetTableViewCell {
                // ContentのIDと一致するロード済みの画像がある場合にCellのthumbnailにセット
                if let image = imageArrayWithIndexPath?[contentsInfoModel[indexPath.row].id] {
                    cell.thumbnail.image = image
            }
   
            cell.cellsIdType = tweetViewController
            cell.setCell(content: contentsInfoModel[indexPath.row], indexPathRow: indexPath.row)
            
//            // 画像の追加があった場合はここで追加する
//            if indexPath.row == fixNumber {
//                if resistedImage != nil {
//                    cell.thumbnail.image = resistedImage
//                }
//            }
            
            return cell
        }
        return UITableViewCell()
    }

    // cellの高さを文字量に合わせる
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

