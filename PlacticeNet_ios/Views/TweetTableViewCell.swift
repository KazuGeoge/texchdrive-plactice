//
//  TweetTableViewCell.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol EditCell {
    func pushEditCellView(indexPathRow: Int)
    func removeCell(indexPathRow: Int)
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteItem: UIButton!
    @IBOutlet weak var editItem: UIButton!
    var editCellDelegate: EditCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 指定のCellの文字編集画面に遷移を親Viewに委譲
    @IBAction func editButton(_ sender: UIButton) {
        editCellDelegate?.pushEditCellView(indexPathRow: editItem.tag)
    }
    
    // 指定のCellを削除を親Viewに委譲
    @IBAction func deleteButton(_ sender: UIButton) {
        editCellDelegate?.removeCell(indexPathRow: deleteItem.tag)
    }
}
