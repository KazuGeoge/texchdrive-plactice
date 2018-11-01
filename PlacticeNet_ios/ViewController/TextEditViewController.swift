//
//  TextViewEditViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/22.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol UpLoadType {
    func putMessage(tweet: String, textID: Int)
}

protocol TableReloadDelegate {
    func reloadData()
}

class TextEditViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    var tableViewDataSouce: TableViewDataSouce = TableViewDataSouce()
    var tweetTableViewCell: TweetTableViewCell = TweetTableViewCell()
    var upLoadAPIData: UPLoadAPIData = UPLoadAPIData()
    var readAPIData: ReadAPIData = ReadAPIData()
    var tableReloadDelegate: TableReloadDelegate?
    var upLoadType: UpLoadType?
    var editMessage: String?
    var indexPath: Int?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = editMessage
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = true
        upLoadType = upLoadAPIData
    }
    
    // キーボード以外をタッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // 編集した文字を適用しViewを閉じる
    @IBAction func setEditedText(_ sender: Any) {
        
        if indexPath != nil {
            if let tweetString = textView.text {
                tableViewDataSouce.messageContents[indexPath!] = tweetString // nil無しの条件のためアンラップを許容
                let tweetID = tableViewDataSouce.textIDArray[indexPath!]
                upLoadType?.putMessage(tweet: tweetString, textID: tweetID)
                tableReloadDelegate?.reloadData()
                dismiss(animated: true, completion: nil)
            }
        // TableViewのCellが特定出来ない場合は操作やり直し
        } else {
            // アラートを表示
            let alertController = UIAlertController(title: "IndexError", message: "操作をやり直してください", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "戻る", style: .cancel, handler: { OKAction in
                self.dismiss(animated: true, completion: nil)
                    }
                )
            )
            present(alertController, animated: true, completion: nil)
        }
    }
   
    // 編集を取り消しViewを閉じる
    @IBAction func cancelEditedText(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
