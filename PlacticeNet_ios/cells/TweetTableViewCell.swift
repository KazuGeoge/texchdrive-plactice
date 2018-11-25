//
//  TweetTableViewCell.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol CellsIdType {
    func pushEditCellView(indexPathRow: Int)
    func removeCell(indexPathRow: Int)
}

protocol ImageType {
    func setImage(imageURL: String)
}

protocol ImageDelegate {
    func getImage(image: UIImage)
}

class TweetTableViewCell: UITableViewCell, ImageDelegate {

    @IBOutlet weak var deleteItem: UIButton!
    @IBOutlet weak var editItem: UIButton!
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    var cellsIdType: CellsIdType?
    var readAPIData: ReadAPIData = ReadAPIData()
    var imageAPIModel: ImageAPIModel = ImageAPIModel()
    var tableReloadDelegate: TableReloadDelegate?
    var imageType: ImageType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(content: ContentsInfoModel, indexPathRow: Int) {
        imageType = imageAPIModel
//        let messageInfo = content
        messageLabel.text = content.contents
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.numberOfLines = 10
        // 行数把握のため各ボタンのtagにindex番号を取得
        deleteItem.tag = indexPathRow
        editItem.tag = indexPathRow
        
        if content.url?.hasPrefix(Const.BASE_STRING) == false {
            if let imageURL = content.url {
                imageAPIModel.imageDelegate = self
                imageType?.setImage(imageURL: imageURL)
                print("画像のURL:\(imageURL)")
            }
        }
    }
    
    func getImage(image: UIImage) {
        thumbnail.image = nil
        thumbnail.image = image
        
    }
    
    // 指定のCellの文字編集画面に遷移を親Viewに委譲
    @IBAction func editButton(_ sender: UIButton) {
        tableReloadDelegate?.reloadData()
        cellsIdType?.pushEditCellView(indexPathRow: editItem.tag)
    }
    
    // 指定のCellを削除、を親Viewに委譲
    @IBAction func deleteButton(_ sender: UIButton) {
        tableReloadDelegate?.reloadData()
        cellsIdType?.removeCell(indexPathRow: deleteItem.tag)
    }
}
