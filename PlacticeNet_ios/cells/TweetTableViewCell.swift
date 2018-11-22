//
//  TweetTableViewCell.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit
import Accounts

protocol CellsIdType {
    func pushEditCellView(indexPathRow: Int)
    func removeCell(indexPathRow: Int)
}

protocol TableReloadDataDelegate {
    func tableViewReload()
}

protocol CellsContentType {
    func showActivity(text: String, image: UIImage)
}

protocol TapedImageType {
    func showImage(imageView: UIImageView)
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteItem: UIButton!
    @IBOutlet weak var editItem: UIButton!
    @IBOutlet weak var shareItem: UIButton!
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var user_IdLabel: UILabel!
    
    var cellsIdType: CellsIdType?
    var tableReloadDataDelegate: TableReloadDataDelegate?
    var cellsContentType: CellsContentType?
    var tapedImageType: TapedImageType?
    
    override func prepareForReuse() {
        super.prepareForReuse()
         // 画像読み込みが終わらずにCell再利用になった場合はthumbnailを初期化する
         thumbnail.image = UIImage(named: "noImage")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureImageTapableView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(content: ContentsInfoModel, indexPathRow: Int) {
        
        messageLabel.text = content.contents
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.numberOfLines = 10
        
        if let userId = content.user_id {
            user_IdLabel.text = "ユーザーID:" + String(userId)
            user_IdLabel.font = UIFont.boldSystemFont(ofSize: 12)
        }
        // 行数把握のため各ボタンのtagにindex番号を取得
        deleteItem.tag = indexPathRow
        editItem.tag = indexPathRow
    }
    
    // 指定のCellの文字編集画面に遷移を親Viewに委譲
    @IBAction func editButton(_ sender: UIButton) {
        cellsIdType?.pushEditCellView(indexPathRow: editItem.tag)
    }
    
    // 指定のCellを削除、を親Viewに委譲
    @IBAction func deleteButton(_ sender: UIButton) {
        cellsIdType?.removeCell(indexPathRow: deleteItem.tag)
    }
    
    // Messageといimageをシェア
    @IBAction func shareButton(_ sender: UIButton) {
        
        if let messageText = messageLabel.text {
            if let thumbnailImage = thumbnail.image {
                cellsContentType?.showActivity(text: messageText, image: thumbnailImage)
            }
        }
    }
    // thumbnail画像をタップで詳細表示
    private func configureImageTapableView() {
        thumbnail.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewOnTap))
        thumbnail.addGestureRecognizer(recognizer)
    }
    // thumbnail選択時の実装
    @objc func imageViewOnTap(sender: UITapGestureRecognizer) {
        tapedImageType?.showImage(imageView: thumbnail)
    }
}


//    // for @IBAction
//    extension TweetTableViewCell {
//        // 指定のCellの文字編集画面に遷移を親Viewに委譲
//        @IBAction func editButton(_ sender: UIButton) {
//            tableReloadDelegate?.reloadData()
//            cellsIdType?.pushEditCellView(indexPathRow: editItem.tag)
//        }
//
//        // 指定のCellを削除、を親Viewに委譲
//        @IBAction func deleteButton(_ sender: UIButton) {
//            tableReloadDelegate?.reloadData()
//            cellsIdType?.removeCell(indexPathRow: deleteItem.tag)
//        }
//    }

