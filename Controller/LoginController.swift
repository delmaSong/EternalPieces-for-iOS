//
//  LoginController.swift
//  EternalPieces
//
//  Created by delma on 31/07/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class LoginController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet var loginId: UITextField!
    @IBOutlet var loginPwd: UITextField!
    
    var loginList : [LoginVO]!
    var loginDAO = LoginDAO()
    
    override func viewDidLoad() {
//        self.loginList = self.loginDAO.login(id: <#T##String!#>, pw: <#T##String!#>)
    }
    
    //바깥 아무데나 누르면 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //로그인 버튼 눌렀을때
    @IBAction func doLogin(_ sender: Any) {
        var inputId = self.loginId.text
        var inputPw = self.loginPwd.text

       
        
        //입력 값 없으면 알럿
        if self.loginId.text == "" || self.loginPwd.text == "" {
            let alert = UIAlertController(title:"Alert!", message: "아이디와 비밀번호를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default) {
                (action) in
                
                
            }
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        //아이디와 비밀번호 맞을 때
        }else if self.loginDAO.login(id: inputId, pw: inputPw) == true {
           
            let ad = UIApplication.shared.delegate as? AppDelegate
            
            ad?.paramId = self.loginId.text
            ad?.paramPwd = self.loginPwd.text
            
            if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "FindStyle"){
                
                lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                
                self.present(lmc, animated: true)
            }
            
        //아이디와 비밀번호 틀렸을 때 알럿
        }else {
            let alert = UIAlertController(title:"Alert!", message: "아이디와 비밀번호를 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default) {
                (action) in
                
                
            }
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
