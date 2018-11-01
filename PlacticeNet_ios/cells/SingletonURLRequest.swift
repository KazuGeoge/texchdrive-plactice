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
    
    static var req : URLRequest = {
        let baseURL = URL (string: Const.LOGIN_STRING)
        let instance = URLRequest(url: baseURL!) // 上記で設定のためnil無し
        return instance
    }()
    
    private init() { }
    
    // ログインのためにメールアドレスを送信
    static func loginView(mailAddress: String) {
        let loginURL = URL(string: Const.LOGIN_STRING)
        let mailAdress:[String: String] = ["email": mailAddress]
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.url = loginURL
        req.httpBody = try? JSONSerialization.data(withJSONObject: mailAdress)
    }
    
    // 全てのContentsを取得する
    static func getAllMessage() {
        let createURL = URL(string: Const.BASE_STRING)
        req.httpMethod = "GET"
        req.url = createURL
        req.httpBody = nil
    }
    
    // 投稿したContentsを送信
    static func createMessage()  {
        let createURL = URL(string: Const.CREATE_STRING)
        req.httpMethod = "POST"
        req.url = createURL
    }
    
    // 編集したContentsを送信、URLの最後に編集するContentsのidを追加
    static func upLoadMessage(textID: Int)  {
        let url = Const.BASE_STRING + String(textID)
        req.url = URL(string: url)
        req.httpMethod = "PUT"
    }
    
    // 削除するContentsを送信、URLの最後に編集するContentsのidを追加
    static func deleteMessage(textID: Int)  {
        let url = Const.BASE_STRING + String(textID)
        req.url = URL(string: url)
        req.httpMethod = "DELETE"
        req.httpBody = nil
    }
}
