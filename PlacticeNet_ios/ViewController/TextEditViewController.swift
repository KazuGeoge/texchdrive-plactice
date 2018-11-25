//
//  TextViewEditViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/22.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit
import AssetsLibrary

protocol UploadType {
    func putMessage(tweet: String, textid: Int)
}

protocol TableReloadDelegate {
    func reloadData()
}

protocol UploadImageType {
    func setImage(textid: Int, image: UIImage)
}

class TextEditViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var textView: UITextView!
    var tableViewDataSouce: TableViewDataSouce = TableViewDataSouce()
    var tweetTableViewCell: TweetTableViewCell = TweetTableViewCell()
    var uploadAPIData: UploadAPIData = UploadAPIData()
    var readAPIData: ReadAPIData = ReadAPIData()
    var imageUploadAPIData: ImageUploadAPIData = ImageUploadAPIData()
    var tableReloadDelegate: TableReloadDelegate?
    var uploadType: UploadType?
    var editMessage: String?
    var indexPath: Int?
    var uploadImageType: UploadImageType?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = editMessage
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = true
        uploadType = uploadAPIData
        uploadImageType = imageUploadAPIData
    }
    
    // キーボード以外をタッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // 編集した文字を適用しViewを閉じる
    @IBAction func setEditedText(_ sender: Any) {
        
        if let tweetString = textView.text {
            if let idexPathRow = indexPath {
                tableViewDataSouce.contentsInfoModel[idexPathRow].contents = tweetString
<<<<<<< HEAD
                    uploadImageType = imageUploadAPIData
                    
                    uploadType?.putMessage(tweet: tweetString, textId: tableViewDataSouce.contentsInfoModel[idexPathRow].id)
                    tableViewDataSouce.contentsInfoModel[idexPathRow].contents = tweetString
                    
                    if imageView.image != nil {
                        uploadImageType?.setImage(textId: tableViewDataSouce.contentsInfoModel[idexPathRow].id, image: imageView.image)
                    }
                    tableReloadDelegate?.reloadData(textId: tableViewDataSouce.contentsInfoModel[idexPathRow].id, image: imageView.image)
=======
                if let tweetid = tableViewDataSouce.contentsInfoModel[idexPathRow].id {
                    uploadType?.putMessage(tweet: tweetString, textid: tweetid)
                    tableReloadDelegate?.reloadData()
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
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
    
    // カメラロールから写真を選択
    @IBAction func choosePictureButton(_ sender: Any) {
       
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    // カメラを起動
    @IBAction func startCamera(_ sender: Any) {
        
        // カメラが利用可能か?
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true)
        }
    }
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
<<<<<<< HEAD
        if let editsIndexPathRow = indexPath {
                uploadImageType?.setImage(textId: tableViewDataSouce.contentsInfoModel[editsIndexPathRow].id, image: image)
=======
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            // 選択した写真を取得する
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            tableViewDataSouce.fixNumber = indexPath
            tableViewDataSouce.resistedImage = image
            print("選択した画像のURL:\(String(describing: imageUrl))")
            tableReloadDelegate?.reloadData()
            uploadImageType?.setImage(textid: tableViewDataSouce.contentsInfoModel[indexPath!].id!, image: image)
            self.dismiss(animated: true)
>>>>>>> parent of 20bb340... 修正と機能、Viewの追加
        }
    }
}
