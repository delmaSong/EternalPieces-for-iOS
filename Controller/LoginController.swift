//
//  LoginController.swift
//  EternalPieces
//
//  Created by delma on 31/07/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Firebase
import SVProgressHUD

class LoginController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet var loginId: UITextField!
    @IBOutlet var loginPwd: UITextField!
    
    var loginList : [LoginVO]!
    var loginDAO = LoginDAO()
 
    //바깥 아무데나 누르면 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //로그인 버튼 눌렀을때
    @IBAction func doLogin(_ sender: Any) {
//        let inputId = self.loginId.text
//        let inputPw = self.loginPwd.text

//        let params = [
//            "user_id" : inputId,
//            "user_pw" : inputPw
//        ]
//
//        Alamofire.request("http://127.0.0.1:1234/api/login_api/", method: .post, parameters: params, encoding: JSONEncoding.default)
//
        
        //입력 값 없으면 알럿
        if self.loginId.text == "" || self.loginPwd.text == "" {
            let alert = UIAlertController(title:"Alert!", message: "아이디와 비밀번호를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default) {
                (action) in
                
                
            }
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else{
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: self.loginId.text!, password: self.loginPwd.text!) { (user, error) in
                if error != nil {
                    print(error!)
                }else{
                    SVProgressHUD.dismiss()
                    if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as? ViewController {
                                    lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                                    self.present(lmc, animated: true)
                                }
                }
            }
        }
//        //아이디와 비밀번호 맞을 때
//        }else if self.loginDAO.login(id: inputId, pw: inputPw) == true {
//
//            let ad = UIApplication.shared.delegate as? AppDelegate
//
//            ad?.paramId = self.loginId.text
//            ad?.paramPwd = self.loginPwd.text
//
//            if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "LoginedMain"){
//
//                lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//
//                self.present(lmc, animated: true)
//            }
//
//        //아이디와 비밀번호 틀렸을 때 알럿
//        }else {
//            let alert = UIAlertController(title:"Alert!", message: "아이디와 비밀번호를 확인해주세요", preferredStyle: UIAlertController.Style.alert)
//
//            let defaultAction = UIAlertAction(title: "OK", style: .default) {
//                (action) in
//
//
//            }
//            alert.addAction(defaultAction)
//            present(alert, animated: true, completion: nil)
//        }
    }
    
}
