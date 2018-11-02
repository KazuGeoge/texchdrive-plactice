//
//  sendAPIData.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/25.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol LogInDelegate {
    func logInView()
}

protocol ErrorType {
    func alertErrorMessage()
}

class SendAPIData: LoginType {
    
    var logInDelegate: LogInDelegate?
    var errorType: ErrorType?
    
    func postMail(mailAddress: String) {
        
        if let req = SingletonURLRequest.loginView(mailAddress: mailAddress) {
            
            URLSession.shared.dataTask(with: req) { (data, responce, error) in
                
                if error != nil {
                    print(error!.localizedDescription) // nil無しの条件のため!を許容
                }
                
                guard let data = data,
                    let jsonData = try? JSONDecoder().decode(TokenModel.self, from: data) else {
                        return
                }
                
                if let responce = responce as? HTTPURLResponse {
                    DispatchQueue.main.sync {
                        
                        // ログインが成功なら全Contentsを取得するデリゲートを委譲する
                        if responce.statusCode == 200 {
                            self.logInDelegate?.logInView()
                            // 返ってきたトークンをSingletonのtokenにセット
                            SingletonURLRequest.singleToken = jsonData.token
                        } else {
                            self.errorType?.alertErrorMessage()
                        }
                    }
                }
            }
                .resume()
        }
    }
}
