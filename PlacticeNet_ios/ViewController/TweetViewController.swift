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
    func deleteMessage(textId: Int)
}

protocol ImageWithMessageIdType {
    func setImage(messageInfo: [ContentsInfoModel])
}

class TweetViewController: UIViewController, UITextViewDelegate, CellsIdType, TableReloadDelegate, SetMessageDelegate, NewMessageDelegate, ToTweetViewImage, ImageDelegate, CellsContentType, TableDelegate, TapedImageType {
   
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takeImageOutlet: UIButton!
    @IBOutlet weak var cameraRollOutlet: UIButton!
    @IBOutlet weak var tweetButtonOutllet: UIButton!
    @IBOutlet weak var textViewHight: NSLayoutConstraint!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var tweetButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var tweetButtonWidth: NSLayoutConstraint!
    private var isFarstTouch = true
    private var tweetImage: UIImage?
    private var imageArrayWithMessageId: [Int: UIImage] = [:]
    // クラスのインスタンス
    var tableViewDataSouce: TableViewDataSouce = TableViewDataSouce()
    var tweetTableViewCell: TweetTableViewCell = TweetTableViewCell()
    var textEditView: TextEditViewController = TextEditViewController()
    var shareView: ShareView = ShareView()
    var imageViewController: ImageViewController = ImageViewController()
    var readAPIData: ReadAPIData = ReadAPIData()
    var createAPIData: CreateAPIData = CreateAPIData()
    var deleteAPIData: DeleteAPIData = DeleteAPIData()
    var imagePickerView: ImagePickerView = ImagePickerView()
    var imageUploadAPIData: ImageUploadAPIData = ImageUploadAPIData()
    var imageAPIModel: ImageAPIModel = ImageAPIModel()
    // デリゲートのインスタンス
    var deleteType: DeleteType?
    var getAllType: GetAllType?
    var createType: CreateType?
    var newMessageDelegate: NewMessageDelegate?
    var uploadImageType: UploadImageType?
    var toTweetViewImage: ToTweetViewImage?
    var imageWithMessageIdType: ImageWithMessageIdType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureTableView()
        configureUI()
        setDelegate()
        tweetButtonOutllet.isUserInteractionEnabled = false
        tweetButtonOutllet.alpha = 0.1
        tableView.isUserInteractionEnabled = true
        
        
        dump(ContentsInfoModel.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
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
        tableViewDataSouce.parentViewController = self
        tableViewDataSouce.tableDelegate = self
        tableViewDataSouce.tweetVC = self
        readAPIData.setMessageDelegate = self
        createAPIData.newMessageDelegate = self
        getAllType = readAPIData
        createType = createAPIData
        deleteType = deleteAPIData
        getAllType?.getAllMessage()
        imagePickerView.toTweetViewImage = self
        uploadImageType = imageUploadAPIData
        imageWithMessageIdType = imageAPIModel
        imageAPIModel.imageDelegate = self
    }
    
    // 全取得したContentsをtableViewDataSouceにセットする
    func setMessageData(messageInfo: [ContentsInfoModel]) {
        tableViewDataSouce.contentsInfoModel = []
        tableViewDataSouce.contentsInfoModel = messageInfo
        // 画像のURLは別のModelで一斉に読み込む
        imageWithMessageIdType?.setImage(messageInfo: messageInfo)
        tableView.reloadData()
    }
    
    // 取得した画像をtextIDとの辞書型で格納
    func getImage(image: UIImage, messageId: Int) {
        imageArrayWithMessageId.updateValue(image, forKey: messageId)
        tableViewDataSouce.imageArrayWithIndexPath = imageArrayWithMessageId
        tableView.reloadData()
    }
    
    // textViewが選択された時の挙動
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        UIView.animate(withDuration: 0.2) {
            self.takeImageOutlet.alpha = 0
            self.cameraRollOutlet.alpha = 0
            self.imageView.alpha = 0
        }
        
        // 初期設定の"入力してください"を削除
        if isFarstTouch == true {
            textView.text = ""
            isFarstTouch = false
        }
        
        textViewHight.constant = textView.sizeThatFits(textView.frame.size).height
        textViewTrailing.constant = 40
        tweetButtonTrailing.constant = 40
        textView.alpha = 1
        tweetButtonOutllet.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        
        // Buttonwの大きさを変更
        UIButton.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.view.layoutIfNeeded()
            self.tweetButtonOutllet.transform = CGAffineTransform(scaleX: 2.5, y: 1)
            
        }, completion: nil)
        
        // 上記で変更したサイズを１秒かけて再描画する
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // 入力された文字に合わせてtextViewの大きさを調節
    func textViewDidChange(_ textView: UITextView) {
        // 入力フィールドの最大サイズ
        let maxHeight = 160.0
        
        if textView.frame.size.height.native <= maxHeight {
            textViewHight.constant = textView.sizeThatFits(textView.frame.size).height
        }
        // 入力があったら投稿ボタンを使用可能に
        if textView.text.isEmpty == false && isFarstTouch == false {
            tweetButtonOutllet.isUserInteractionEnabled = true
            tweetButtonOutllet.alpha = 1
        } else {
            tweetButtonOutllet.isUserInteractionEnabled = false
            tweetButtonOutllet.alpha = 0.1
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
        
        if let contents = textView.text {
            textView.text = ""
            createType?.createMessage(tweet: contents)
        }
        defaultTextViewSize()
    }
    
    // 投稿したContentsのIDと内容をtableViewDataSouceの先頭にセットする
    func setNewMessageData(content: ContentsInfoModel) {
        tableViewDataSouce.contentsInfoModel.insert(content, at: 0)
        if let newImage = tweetImage {
                imageArrayWithMessageId.updateValue(newImage, forKey: content.id)
                tableViewDataSouce.imageArrayWithIndexPath = imageArrayWithMessageId
                uploadImageType?.setImage(textId: content.id, image: newImage)
        }
        tableView.reloadData()
        tweetImage = nil
        imageView.image = nil
    }
    
    // アニメーションで各Itemのサイズを元に戻す
    private func defaultTextViewSize() {
        self.textViewTrailing.constant = 10
        self.tweetButtonTrailing.constant = 10
        self.textViewHight.constant = 160
        self.tweetButtonOutllet.transform = CGAffineTransform(scaleX: 1, y: 1)
        tweetButtonOutllet.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // 上記で変更したサイズを１秒かけて再描画する
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.takeImageOutlet.alpha = 1
            self.cameraRollOutlet.alpha = 1
            self.imageView.alpha = 1
        }
    }
    
    func showImage(imageView: UIImageView) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageVC = mainStoryboard.instantiateViewController(withIdentifier: "ImageView") as? ImageViewController {
            imageVC.tapedImageView = imageView
            present(imageVC, animated: true, completion: nil)
        }
    }
    
    // 編集画面に遷移し編集するデータを渡す
    func pushEditCellView(indexPathRow: Int) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let textEditView = mainStoryboard.instantiateViewController(withIdentifier: "TextView") as? TextEditViewController {
            textEditView.tableViewDataSouce = tableViewDataSouce
            textEditView.editMessage = tableViewDataSouce.contentsInfoModel[indexPathRow].contents
            textEditView.indexPath = indexPathRow
            textEditView.addImage = imageArrayWithMessageId[tableViewDataSouce.contentsInfoModel[indexPathRow].id]
            textEditView.tableReloadDelegate = self
            present(textEditView, animated: true, completion: nil)
        }
    }
    
    // 編集画面の変更を反映
    func reloadData(textId: Int, image: UIImage?) {
        if image != nil {
            imageArrayWithMessageId[textId] = image
            tableViewDataSouce.imageArrayWithIndexPath = imageArrayWithMessageId
        }
        tableView.reloadData()
    }
    
    // 削除ボタンが押されたらアラートを出しOKなら削除する
    func removeCell(indexPathRow: Int) {
        let alertController = UIAlertController(title: "削除確認", message: "削除してよろしいですか？", preferredStyle: .alert)
        // キャンセルボタン
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        // OKボタン
        alertController.addAction(UIAlertAction(title: "OK!", style: .default, handler: { OKAction in
                self.deleteType?.deleteMessage(textId: self.tableViewDataSouce.contentsInfoModel[indexPathRow].id)
                
                //セクションの種類は一つのためindexPathRowのみでindexPathを取得
                let indexPath:IndexPath = [0, indexPathRow]
                self.tableViewDataSouce.contentsInfoModel.remove(at: indexPathRow)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }
        ))
        // アラートを表示
        present(alertController, animated: true, completion: nil)
    }
    
    // シェアボタンが押されたら引数で受け取ったContentの共有モーダルを表示する
    func showActivity(text: String, image: UIImage) {
        let activityViewController = shareView.showActivityViewController(willShareText: text, willShareImage: image)
        present(activityViewController, animated: true)
    }
    
    @IBAction func takeImageButton(_ sender: Any) {
        
        if let cameraView = imagePickerView.startUpCamera(isFromTextEditView: false) {
            self.present(cameraView, animated: true)
        }
    }
    
    @IBAction func openCameraRoll(_ sender: Any) {
        
        if let cameraRoll = imagePickerView.openCameraRoll(isFromTextEditView: false) {
            self.present(cameraRoll, animated: true)
        }
    }
    
    func pushViewController(tweetView: UIViewController) {
         navigationController?.pushViewController(tweetView, animated: true)
    }
    
    
    func setSelectedImage(image: UIImage) {
        tweetImage = image
        imageView.image = tweetImage
        self.dismiss(animated: true)
    }
}
