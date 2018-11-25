//
//  TweetDetailViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/22.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var user_Id: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var user_IdInt: Int?
    var indexPathRow: Int?
    var tweetContents: String?
    var image: UIImage?
    var isFromTweetView: Bool?
    var cellsIdType: CellsIdType?
    var cellsContentType: CellsContentType?
    var tapedImageType: TapedImageType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTweetContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromTweetView == false {
            navigationController?.popViewController(animated: true)
        }
        isFromTweetView = false
    }
    
    private func configureTweetContent() {
        
        if let user_IdString = user_IdInt {
            user_Id.text = "ユーザーID:" + String(user_IdString)
        }
        
        if let tweetDetetailContent = tweetContents {
            tweetContent.text = tweetDetetailContent
        }
        
        if image != UIImage(named: "noImage") {
            imageView.image = image
            configureImageTapableView()
        }
        
        tweetContent.numberOfLines = 10
    }
    
    // 画像をタップで詳細表示
    private func configureImageTapableView() {
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewOnTap))
        imageView.addGestureRecognizer(recognizer)
    }
    // 画像タップ選択時の実装
    @objc func imageViewOnTap(sender: UITapGestureRecognizer) {
        tapedImageType?.showImage(imageView: imageView)
    }
    
    // 編集画面に遷移を親Viewに委譲
    @IBAction func textEditButton(_ sender: Any) {
        
        if let detailsIndexPathRow = indexPathRow {
            cellsIdType?.pushEditCellView(indexPathRow: detailsIndexPathRow)
        }
    }
    
    // Cellの削除を親Viewに委譲
    @IBAction func textDeleteButton(_ sender: Any) {
        
        if let detailsIndexPathRow = indexPathRow {
            cellsIdType?.removeCell(indexPathRow: detailsIndexPathRow)
        }
    }
    
    // Messageといimageをシェア
    @IBAction func sharedContentButton(_ sender: Any) {
        
        if let messageText = tweetContent.text {
            if let thumbnailImage = imageView.image {
                cellsContentType?.showActivity(text: messageText, image: thumbnailImage)
            }
        }
    }
}
