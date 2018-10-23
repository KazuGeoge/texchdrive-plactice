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
    var tweetContents: [String] = []
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
        return tweetContents.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TweetTableViewCell {
            let contentString = tweetContents[indexPath.row]
            cell.textLabel?.text = contentString
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.numberOfLines = 10
            cell.editCellDelegate = editCell
            // 各ボタンのtagにindex番号を渡す
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

