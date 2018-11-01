//
//  ViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

protocol LoginType {
    func postMail(mailAddress: String)
}

class LoginViewController: UIViewController, UITextFieldDelegate, LogInDelegate, ErrorType {
   
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loginItem: UIButton!
    var readAPIData: ReadAPIData = ReadAPIData()
    var sendAPIData: SendAPIData = SendAPIData()
    var loginType: LoginType?
    var logInDelegate: LogInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.gray
        navigationController?.setNavigationBarHidden(false, animated: false)
        textField.delegate = self
        loginItem.alpha = 0
        loginItem.isEnabled = false
        loginType = sendAPIData
        sendAPIData.logInDelegate = self
        sendAPIData.errorType = self
    }
    
    // リターンでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        animateButton()
        textField.resignFirstResponder()
        return true
    }
    
     // キーボード以外をタッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateButton()
        view.endEditing(true)
    }
    
    // textFieldに入力があったら遷移ボタンを出す
    private func animateButton() {
        
        if textField.text?.isEmpty == false {
            UIButton.animate(withDuration: 1) {
                self.loginItem.alpha = 1
            }
            loginItem.isEnabled = true
        } else {
            loginItem.isEnabled = false
            loginItem.alpha = 0
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        if let loginAddress = textField.text {
            loginType?.postMail(mailAddress: loginAddress)
        }
    }
    
    func logInView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let teewtView = mainStoryboard.instantiateViewController(withIdentifier: "TweetView") as? TweetViewController {
            navigationController?.pushViewController(teewtView, animated: true)
        }
    }
    
    func alertErrorMessage() {
        // アラートを表示
        let alertController = UIAlertController(title: "ログインに失敗しました", message: "メールアドレスを見直して下さい", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "やり直す", style: .cancel, handler: { OKAction in
            self.dismiss(animated: true, completion: nil)
                }
            )
        )
        present(alertController, animated: true, completion: nil)
    }
}

