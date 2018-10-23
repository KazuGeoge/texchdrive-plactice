//
//  TweetViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate, EditCell, TableViewReload {
   
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetButtonItem: UIButton!
    @IBOutlet weak var tweetButtonHight: NSLayoutConstraint!
    @IBOutlet weak var tweetButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var textViewHight: NSLayoutConstraint!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    var tableViewDataSouce: TableViewDataSouce = TableViewDataSouce()
    var tweetTableViewCell: TweetTableViewCell = TweetTableViewCell()
    var textEditView: TextEditViewController = TextEditViewController()
    private var isFarstTouch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureTableView()
        tweetButtonItem.layer.borderWidth = 0.5
        tweetButtonItem.layer.cornerRadius = 5.0
        tweetButtonItem.layer.borderColor = UIColor.black.cgColor
    }
    
    private func configureTableView() {
        tableView.delegate = tableViewDataSouce
        tableView.dataSource = tableViewDataSouce
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewDataSouce.editCell = self
    }
    
    private func configureTextView() {
        textView.delegate = self
        textView.text = "入力してください"
        textView.alpha = 0.2
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = true
    }
    
    // textViewが選択された時の挙動
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // 初期設定の"入力してください"を削除
        if isFarstTouch == true {
            textView.text = ""
            isFarstTouch = false
        }
        
        // TextViewとButtonwの大きさを変更
        textView.alpha = 1
        textViewTrailing.constant = 50
        tweetButtonHight.constant = 40
        tweetButtonWidth.constant = 90
        textViewHight.constant = textView.sizeThatFits(textView.frame.size).height
    }
    
    // 入力された文字に合わせてtextViewの大きさを調節
    func textViewDidChange(_ textView: UITextView) {
        // 入力フィールドの最大サイズ
        let maxHeight = 160.0
        
        if textView.frame.size.height.native <= maxHeight {
            textViewHight.constant = textView.sizeThatFits(textView.frame.size).height
        }
    }
    
    // キーボード以外をタッチで下がる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultTextViewSize()
        view.endEditing(true)
    }
    
    // 投稿ボタンで入力した文字をTableViewへ反映する
    @IBAction func tweetButton(_ sender: Any) {
        textView.resignFirstResponder()
        
        if textView.text.isEmpty == false && isFarstTouch == false {
            tableViewDataSouce.tweetContents.append(textView.text)
            textView.text = ""
            tableView.reloadData()
        } else {
            // アラートを表示
            let alertController = UIAlertController(title: "Text is empty", message: "文字の入力がありません", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "戻る", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        defaultTextViewSize()
    }
    
    // 各Itemのサイズを元に戻す
    private func defaultTextViewSize() {
        textViewTrailing.constant = 10
        tweetButtonHight.constant = 30
        tweetButtonWidth.constant = 30
        textViewHight.constant = 160
    }
    
    // 編集画面に遷移し編集するデータを渡す
    func pushEditCellView(indexPathRow: Int) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let textEditView = mainStoryboard.instantiateViewController(withIdentifier: "TextView") as? TextEditViewController {
            textEditView.tableViewDataSouce = tableViewDataSouce
            textEditView.editTarget = tableViewDataSouce.tweetContents[indexPathRow]
            textEditView.indexPath = indexPathRow
            textEditView.tableViewReload = self
            present(textEditView, animated: true, completion: nil)
        }
    }
    
    // 編集画面の変更を反映
    func reloadData() {
        tableView.reloadData()
    }
    
    // 削除ボタンが押されたらアラートを出しOKなら削除する
    func removeCell(indexPathRow: Int) {
        let alertController = UIAlertController(title: "削除確認", message: "削除してよろしいですか？", preferredStyle: .alert)
        // キャンセルボタン
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        // OKボタン
        alertController.addAction(UIAlertAction(title: "OK!", style: .default, handler: {
            OKAction in self.tableViewDataSouce.tweetContents.remove(at: indexPathRow)
            self.tableView.reloadData()
        }
            )
        )
        // アラートを表示
        present(alertController, animated: true, completion: nil)
    }
}
