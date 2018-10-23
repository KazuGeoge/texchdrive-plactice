//
//  ViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/10/19.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loginItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.gray
        navigationController?.setNavigationBarHidden(false, animated: false)
        textField.delegate = self
        loginItem.alpha = 0
        loginItem.isEnabled = false
    }
    
    // リターンでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        buttonAnimate()
        textField.resignFirstResponder()
        return true
    }
    
     // キーボード以外をタッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonAnimate()
        view.endEditing(true)
    }
    
    // textFieldに入力があったら遷移ボタンを出す
    private func buttonAnimate() {
        
        if textField.text?.isEmpty == false {
            UIButton.animate(withDuration: 1) {
                self.loginItem.alpha = 1
                self.loginItem.isEnabled = true
            }
        } else {
            loginItem.isEnabled = false
            loginItem.alpha = 0
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
// TODO: 今は全て遷移可能。textFieldに入力した文字を判定しログインできる形にする。
//        if textField.text == "" {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let teewtView = mainStoryboard.instantiateViewController(withIdentifier: "TweetView") as? TweetViewController {
                navigationController?.pushViewController(teewtView, animated: true)
//            }
        }
    }
}

