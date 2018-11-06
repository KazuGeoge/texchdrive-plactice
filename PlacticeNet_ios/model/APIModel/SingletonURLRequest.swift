//
//  SingletonURLRequest.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/29.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

// リクエストのインスタンスを一つにし,tokenを保持出来るようにする。
class SingletonURLRequest {
    
    static var singleToken : String = {
        let instance = String() 
        return instance
    }()
    
    private init() { }
    
    // ログインのためにメールアドレスを送信
    static func loginView(mailAddress: String) -> URLRequest? {
        
        if let url = URL(string: Const.LOGIN_STRING) {
            var req = URLRequest(url: url)
            let mailAdress:[String: String] = ["email": mailAddress]
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = try? JSONEncoder().encode(mailAdress)
            
            return req
        }
        return nil
    }
    
    // 全てのContentsを取得する
    static func getAllMessage() -> URLRequest? {
        
        if let url = URL(string: Const.BASE_STRING) {
            var req = URLRequest(url: url)
            req.httpMethod = "GET"
            req.setValue(singleToken, forHTTPHeaderField: "Authorization")
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return req
        }
        return nil
    }
    
    // 投稿したContentsを送信
    static func createMessage(tweetContent: [String:String]) -> URLRequest? {
        
        if let url = URL(string: Const.CREATE_STRING) {
            var req = URLRequest(url: url)
            req.setValue(singleToken, forHTTPHeaderField: "Authorization")
            req.httpMethod = "POST"
            req.httpBody = try? JSONSerialization.data(withJSONObject: tweetContent)
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return req
        }
         return nil
    }
    
    // 編集したContentsを送信、URLの最後に編集するContentsのidを追加
    static func uploadMessage(textID: Int, editedContent: String) -> URLRequest?  {
        
        if let url = URL(string: Const.BASE_STRING + String(textID)) {
            var req = URLRequest(url: url)
            let tweetDic:[String: String] = ["contents": editedContent]
            req.httpMethod = "PUT"
            req.setValue(singleToken, forHTTPHeaderField: "Authorization")
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody =  try? JSONSerialization.data(withJSONObject: tweetDic)
            return req
        }
        return nil
    }
    
        // 削除するContentsを送信、URLの最後に編集するContentsのidを追加
    static func deleteMessage(textID: Int) -> URLRequest? {
        
        if let url = URL(string: Const.BASE_STRING + String(textID)) {
            var req = URLRequest(url: url)
            req.httpMethod = "DELETE"
            req.setValue(singleToken, forHTTPHeaderField: "Authorization")
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return req
        }
        return nil
    }
    
    static func uploadImage(textID: Int,  image: UIImage) -> URLRequest? {
        
        // 画像ファイルを作成
        let jpgImageData = image.jpegData(compressionQuality: 1.0)
        let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("file.jpeg")
        do {
            try jpgImageData!.write(to: fileURL)
        } catch {
           print("書き込み失敗")
        }
       
        print(UIImage(contentsOfFile: fileURL.path)!)
//        print(fileURL.path)
//        let str: String? = String(data: fileURL.path, encoding: .utf8)
        print("imageファイルのString:\(fileURL.path)")
        if let myUrl:URL = URL(string: Const.BASE_STRING + String(textID) + "/images") {
            var req = URLRequest(url: myUrl)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue(SingletonURLRequest.singleToken, forHTTPHeaderField: "Authorization")
            // 画像ファイルをData型に変換しBodyに入れる
            let data: Data? = fileURL.path.data(using: .utf8)
            req.httpBody =  data
            return req
        }
        return nil
}
    // TO DO: トレイリングクロージャーを理解して関数を作る
    static func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    }
    
    static func sync(with url: URL, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: handler)
    }
}
