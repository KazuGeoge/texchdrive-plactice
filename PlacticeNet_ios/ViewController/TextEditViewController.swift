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
    func putMessage(tweet: String, textId: Int)
}

protocol TableReloadDelegate {
    func reloadData(textId: Int, image: UIImage?)
}

protocol UploadImageType {
    func setImage(textId: Int, image: UIImage?)
}

class TextEditViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TakingImageType  {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var tableViewDataSouce: TableViewDataSouce = TableViewDataSouce()
    var uploadAPIData: UploadAPIData = UploadAPIData()
    var imagePickerView: ImagePickerView = ImagePickerView()
    var imageUploadAPIData: ImageUploadAPIData = ImageUploadAPIData()
    var tableReloadDelegate: TableReloadDelegate?
    var uploadType: UploadType?
    var uploadImageType: UploadImageType?
    var editMessage: String?
    var indexPath: Int?
    var addImage: UIImage?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = editMessage
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = true
        uploadType = uploadAPIData
        imagePickerView.takingImageType = self
        
        if addImage != UIImage(named: "noImage") {
            imageView.image = addImage
        }
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
                if let tweetId = tableViewDataSouce.contentsInfoModel[idexPathRow].id {
                    uploadImageType = imageUploadAPIData
                    
                    uploadType?.putMessage(tweet: tweetString, textId: tweetId)
                    tableViewDataSouce.contentsInfoModel[idexPathRow].contents = tweetString
                    
                    if imageView.image != nil {
                        uploadImageType?.setImage(textId: tweetId, image: imageView.image)
                    }
                    tableReloadDelegate?.reloadData(textId: tweetId, image: imageView.image)
                    dismiss(animated: true, completion: nil)
                }
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
        
        if let cameraRoll = imagePickerView.openCameraRoll(isFromTextEditView: true) {
            self.present(cameraRoll, animated: true)
        }
    }
    
    // カメラを起動
    @IBAction func startCamera(_ sender: Any) {

        if let cameraView = imagePickerView.startUpCamera(isFromTextEditView: true) {
            self.present(cameraView, animated: true)
        }
    }
    
    func takeImage(image: UIImage) {
        imageView.image = image
        uploadImageType? = imageUploadAPIData
        
        if let editsIndexPathRow = indexPath {
            if let textId = tableViewDataSouce.contentsInfoModel[editsIndexPathRow].id {
                uploadImageType?.setImage(textId: textId, image: image)
            }
        }
        
        self.dismiss(animated: true)
    }
}
