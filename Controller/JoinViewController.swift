//
//  JoinViewController.swift
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

class JoinViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet var joinId: UITextField!
    @IBOutlet var joinPwd: UITextField!
    @IBOutlet var joinPwd2: UITextField!
    @IBOutlet var nickName: UITextField!
    
    
    @IBOutlet var isTattist: UISwitch!
    @IBOutlet var isTattistText: UILabel!
    
 
    @IBOutlet var ttSwitch: UISwitch!
    
    
   
    
    
    override func viewDidLoad() {
        //화면 켜면 기본값 switch off 
        ttSwitch.isOn = false
        
        //화면 열리면 아이디 텍스트필드에 포커스 및 기본 키보드 영어로 세팅
        self.joinId.placeholder = "이메일"
        self.joinId.keyboardType = UIKeyboardType.alphabet
        //self.joinId.becomeFirstResponder()
        
        self.joinPwd.placeholder = "비밀번호"
        self.joinPwd.keyboardType = UIKeyboardType.alphabet

        self.joinPwd2.placeholder = "비밀번호 확인"
        self.joinPwd2.keyboardType = UIKeyboardType.alphabet
        self.joinPwd2.returnKeyType = UIReturnKeyType.join
        self.joinPwd2.enablesReturnKeyAutomatically = true
    }
  
   //바깥 아무데나 누르면 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //타투이스트 여부 확인 플래그
    var tattistFlag: Bool = false
    
    //타투이스트 여부 스위치
    @IBAction func onSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            self.isTattistText.text = "저는 타투이스트입니다"
            tattistFlag = true
        }else{
            self.isTattistText.text = "저는 타투이스트가 아닙니다"
            tattistFlag = false
        }
    }
    
    //회원가입 버튼 클릭시
    @IBAction func onSubmit(_ sender: Any) {
        //이메일 형식 검사 필요
        //항목 미입력시
        if self.joinId.text == "" || self.joinPwd.text == "" || self.joinPwd2.text == "" || self.nickName.text == "" {
            let alert = UIAlertController(title:"Alert!", message: "항목을 모두 입력해주세요", preferredStyle: UIAlertController.Style.alert)
           let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in}
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
       //아이디 입력 && 비밀번호 두개 다를 경우
        }else if self.joinId.text != "" && self.joinPwd.text != self.joinPwd2.text {
            let alert = UIAlertController(title:"Alert!", message: "비밀번호가 다릅니다", preferredStyle: UIAlertController.Style.alert)
           let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in}
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }else if !self.joinId.text!.validateEmail() {
            let alert = UIAlertController(title:"Alert!", message: "이메일형식에 알맞게 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in}
           alert.addAction(defaultAction)
           present(alert, animated: true, completion: nil)
                       
        }else if self.joinPwd.text!.count < 6 {         //비밀번호 6자 미만일 경우
            let alert = UIAlertController(title:"Alert!", message: "비밀번호를 6자이상 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) {(action) in}
           alert.addAction(defaultAction)
           present(alert, animated: true, completion: nil)
            
            
            //모든 항목 입력 && 타투어
        }else if self.joinId.text != "" && self.joinPwd.text == self.joinPwd2.text && tattistFlag == false{
            
//            //서버에 보낼 데이터
//            let param = [
//                "user_id" : self.joinId.text!,
//                "user_pw" : self.joinPwd.text!,
//                "role_tatt" : false
//            ] as [String : Any]
//
//            //API 호출
//            let url = "http://127.0.0.1:1234/api/login_api/"
//            Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: self.joinId.text!, password: self.joinPwd.text!) { (user, error) in
                let uid = user?.user.uid
                if error != nil {
                    print(error!)
                }else{
                    
                    Database.database().reference().child("users").child(uid!).setValue(["nick" : self.nickName.text!])
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title:"Alert!", message: "회원가입이 완료되었습니다 :)", preferredStyle: UIAlertController.Style.alert)
                      let defaultAction = UIAlertAction(title: "OK", style: .default) {
                          (action) in
                          //로그인 화면으로 이동
                          if let lc = self.storyboard?.instantiateViewController(withIdentifier: "LoginScene"){
                              lc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                              self.present(lc, animated: true)
                          }
                      }
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        //모든 항목 입력 && 타투이스트
        }else if self.joinId.text != "" && self.joinPwd.text == self.joinPwd2.text && tattistFlag == true{
            if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistInfo") as? SetTattistInfoController{
                st.paramId = self.nickName.text!
                st.paramPwd = self.joinPwd.text!
                
                st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                
                self.present(st, animated: true)
            }
        }
    }
    
    
    
    @IBAction func gotoJoin(_segue: UIStoryboardSegue){
        
    }
    
   
//    @IBAction func goToList(_ sender: Any) {
//        if let st = self.storyboard?.instantiateViewController(withIdentifier: "ChatTattooerList"){
//            
//            st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//            
//            self.present(st, animated: true)
//        }
//    }
}

extension String{
    
    //이메일 정규식
    func validateEmail() -> Bool{
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
}
