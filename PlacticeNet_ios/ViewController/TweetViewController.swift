//
//  TweetViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol GetAllType {
    func getAllMessage()
}

protocol CreateType {
     func createMessage(tweet: String)
}

protocol DeleteType {
    func deleteMessage(textID: Int)
}

class TweetViewController: UIViewController, UITextViewDelegate, CellsIdType, TableReloadDelegate, SetMessageDelegate, NewMessageDelegate {
 
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetButtonOutllet: UIButton!
    @IBOutlet weak var textViewHight: NSLayoutConstraint!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var tweetButtonTrailing: NSLayoutConstraint!
    
    private var isFarstTouch = true
    // クラスのインスタンス
    var tableViewDataSouce: TableViewDataSouce = TableViewDataSouce()
    var tweetTableViewCell: TweetTableViewCell = TweetTableViewCell()
    var textEditView: TextEditViewController = TextEditViewController()
    var sendAPIData: SendAPIData = SendAPIData()
    var readAPIData: ReadAPIData = ReadAPIData()
    var createAPIData: CreateAPIData = CreateAPIData()
    var deleteAPIData: DeleteAPIData = DeleteAPIData()
    // デリゲートのインスタンス
    var deleteType: DeleteType?
    var logInDelegate: LogInDelegate?
    var getAllType: GetAllType?
    var createType: CreateType?
    var newMessageDelegate: NewMessageDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureTableView()
        configureUI()
        setDelegate()
    }
    
    private func configureTextView() {
        textView.delegate = self
        textView.text = "入力してください"
        textView.alpha = 0.2
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = true
    }
    
    private func configureTableView() {
        tableView.delegate = tableViewDataSouce
        tableView.dataSource = tableViewDataSouce
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func configureUI(){
        tweetButtonOutllet.layer.borderWidth = 0.5
        tweetButtonOutllet.layer.cornerRadius = 5.0
        tweetButtonOutllet.layer.borderColor = UIColor.black.cgColor
    }
    
    // tableView,textView以外のDelegateの設定
    private func setDelegate() {
        tableViewDataSouce.tweetViewController = self
        readAPIData.setMessageDelegate = self
        createAPIData.newMessageDelegate = self
        getAllType = readAPIData
        createType = createAPIData
        deleteType = deleteAPIData
        getAllType?.getAllMessage()
        
    }
    
    // 全取得したContentsをtableViewDataSouceにセットする
    func setMessageData(messageInfo: [ContentsInfoModel]) {
        tableViewDataSouce.contentsInfoModel = []
        tableViewDataSouce.contentsInfoModel = messageInfo
        tableView.reloadData()
    }
   
    // textViewが選択された時の挙動
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // 初期設定の"入力してください"を削除
        if isFarstTouch == true {
            textView.text = ""
            isFarstTouch = false
        }
        
        textViewHight.constant = textView.sizeThatFits(textView.frame.size).height
        textViewTrailing.constant = 40
        tweetButtonTrailing.constant = 40
        // TextViewとButtonwの大きさを変更
        UITextView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.tweetButtonOutllet.transform = CGAffineTransform(scaleX: 2.5, y: 1)
        }, completion: nil)
        textView.alpha = 1
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
    
    // 投稿ボタンで、Contentsを送信するデリゲートの委譲を設定
    @IBAction func tweetButtonAction(_ sender: Any) {
        textView.resignFirstResponder()
        
        if textView.text.isEmpty == false && isFarstTouch == false {
            if let contents = textView.text {
                textView.text = ""
                createType?.createMessage(tweet: contents)
            }
        } else {
            // アラートを表示
            let alertController = UIAlertController(title: "Text is empty", message: "文字の入力がありません", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "戻る", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        defaultTextViewSize()
    }
    
    // 投稿したContentsのidと内容をtableViewDataSouceの先頭にセットする
    func setNewMessageData(content: ContentsInfoModel) {
        tableViewDataSouce.contentsInfoModel.insert(content, at: 0)
        tableView.reloadData()
    }
    
    // 各Itemのサイズを元に戻す
    private func defaultTextViewSize() {
        textViewTrailing.constant = 10
        tweetButtonTrailing.constant = 10
        textViewHight.constant = 160
        tweetButtonOutllet.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    // 編集画面に遷移し編集するデータを渡す
    func pushEditCellView(indexPathRow: Int) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let textEditView = mainStoryboard.instantiateViewController(withIdentifier: "TextView") as? TextEditViewController {
            textEditView.tableViewDataSouce = tableViewDataSouce
            textEditView.editMessage = tableViewDataSouce.contentsInfoModel[indexPathRow].contents
            textEditView.indexPath = indexPathRow
            textEditView.tableReloadDelegate = self
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
        alertController.addAction(UIAlertAction(title: "OK!", style: .default, handler: { OKAction in
            if let textid = self.tableViewDataSouce.contentsInfoModel[indexPathRow].id {
                self.deleteType?.deleteMessage(textID: textid)
                self.tableViewDataSouce.contentsInfoModel.remove(at: indexPathRow)
                self.tableView.reloadData()
                    }
                }
            )
        )
        // アラートを表示
        present(alertController, animated: true, completion: nil)
    }
}
