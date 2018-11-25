//
//  TableViewDataSouce.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol TableDelegate {
    func pushViewController(tweetView: UIViewController)
}

class TableViewDataSouce: NSObject, UITableViewDataSource, UITableViewDelegate{

    let sectionTitle = ["ツイート"]
    var contentsInfoModel: [ContentsInfoModel] = []
    var tweetViewController: CellsIdType?
    var parentViewController: CellsContentType?
    var tableDelegate: TableDelegate?
    var imageArrayWithIndexPath: [Int: UIImage]?
    var tweetVC: TapedImageType?
    
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> parent of 8d70f37... Revert "修正と機能、Viewの追加"
            
                // ContentのIDと一致するロード済みの画像がある場合にCellのthumbnailにセット
                if let image = imageArrayWithIndexPath?[contentsInfoModel[indexPath.row].id] {
                    cell.thumbnail.image = image
            }
            
<<<<<<< HEAD
=======
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
=======
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
=======
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
=======
>>>>>>> parent of 8d70f37... Revert "修正と機能、Viewの追加"
            cell.cellsIdType = tweetViewController
            cell.cellsContentType = parentViewController
            cell.tapedImageType = tweetVC
            cell.setCell(content: contentsInfoModel[indexPath.row], indexPathRow: indexPath.row)
            
            return cell
        }
        return UITableViewCell()
    }
    
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> parent of 8d70f37... Revert "修正と機能、Viewの追加"
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let tweetDetailVC = mainStoryboard.instantiateViewController(withIdentifier: "TweetDetailView") as? TweetDetailViewController {
           
            tweetDetailVC.user_IdInt = contentsInfoModel[indexPath.row].user_id
            tweetDetailVC.tweetContents = contentsInfoModel[indexPath.row].contents
            tweetDetailVC.indexPathRow = indexPath.row
            tweetDetailVC.cellsIdType = tweetViewController
            tweetDetailVC.cellsContentType = parentViewController
            tweetDetailVC.tapedImageType = tweetVC
            tweetDetailVC.isFromTweetView = true
            //  対象のContentのID
                // ContentのIDと一致するロード済みの画像がある場合にCellのthumbnailをセット
                if let image = imageArrayWithIndexPath?[contentsInfoModel[indexPath.row].id] {
                   tweetDetailVC.image  = image
            }
            tableDelegate?.pushViewController(tweetView: tweetDetailVC)
        }
    }
    
<<<<<<< HEAD
=======
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
=======
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
=======
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
=======
>>>>>>> parent of 8d70f37... Revert "修正と機能、Viewの追加"
    // cellの高さを文字量に合わせる
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

