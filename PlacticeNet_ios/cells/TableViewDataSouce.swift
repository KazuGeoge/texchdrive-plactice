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
    var messageContents: [String] = []
    var textIDArray: [Int] = []
    var contentsList: [BaseContents] = []
    // TODO: TweetVCを入れる方法が他にないか
    var editCell: EditCell?
    
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
        return messageContents.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TweetTableViewCell {
            let contentString = messageContents[indexPath.row]
            let contentID = textIDArray[indexPath.row] 
            cell.textLabel?.text = contentString
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.numberOfLines = 10
            cell.editCellDelegate = editCell
            cell.textID = contentID
            // 行数把握のため各ボタンのtagにindex番号を渡す
            cell.deleteItem.tag = indexPath.row
            cell.editItem.tag = indexPath.row
            return cell
        }
        return UITableViewCell()
    }
    
    // cellの高さを文字量に合わせる
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

