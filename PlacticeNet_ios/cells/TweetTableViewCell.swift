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

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteItem: UIButton!
    @IBOutlet weak var editItem: UIButton!
    var textID: Int?
    var cellsIdType: CellsIdType?
    var readAPIData: ReadAPIData = ReadAPIData()
    var tableReloadDelegate: TableReloadDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
