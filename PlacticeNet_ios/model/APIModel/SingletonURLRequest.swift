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
    
    // URLSessionを開始する
    static func dataTask(with req: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: req, completionHandler: completionHandler)
        task.resume()
    }
    
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
    static func uploadMessage(textId: Int, editedContent: String) -> URLRequest?  {
        
        if let url = URL(string: Const.BASE_STRING + String(textId)) {
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
    
        // 削除するContentsを送信、URLの最後に編集するContentsのIDを追加
    static func deleteMessage(textId: Int) -> URLRequest? {
        
        if let url = URL(string: Const.BASE_STRING + String(textId)) {
            var req = URLRequest(url: url)
            req.httpMethod = "DELETE"
            req.setValue(singleToken, forHTTPHeaderField: "Authorization")
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return req
        }
        return nil
    }
    
    // 選択した画像をアップロード
    static func uploadImage(image: UIImage, textId: Int) -> URLRequest?  {
        let boundary = "----WebKitFormBoundaryZLdHZy8HNaBmUX0d"
        let fileName = "file.jpg"
        if let imageData = image.jpegData(compressionQuality: 1.0) {
        
        if let myUrl:URL = URL(string: Const.BASE_STRING + String(textId) + "/images") {
            var req = URLRequest(url: myUrl)
            req.httpMethod = "POST"
            req.setValue(SingletonURLRequest.singleToken, forHTTPHeaderField: "Authorization")
            req.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            // Bodyの作成
            if var data = "--\(boundary)\r\n".data(using: .utf8) {
                // サーバ側が想定しているinput(message[image]=image)タグのname属性値とファイル名をContent-Dispositionヘッダで設定
                if let contentDisposition = "Content-Disposition: form-data; name=\"message[image]\"; filename=\"\(fileName)\"\r\n".data(using: .utf8) {
                    data += contentDisposition
                    
                    if let contentType = "Content-Type: image/jpg\r\n".data(using: .utf8) {
                        data += contentType
                       
                        if let newLine = "\r\n".data(using: .utf8) {
                            data += newLine
                            data += imageData
                            
                            if let secondNewLine =  "\r\n".data(using: .utf8) {
                                data += secondNewLine
                                
                                if let thirdNewLine = "\r\n--\(boundary)--\r\n".data(using: .utf8) {
                                    data += thirdNewLine
                                }
                            }
                        }
                    }
                }
                req.httpBody = data
            }
            return req
            }
        }
        return nil
    }
}
