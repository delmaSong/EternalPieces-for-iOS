//
//  JoinViewController.swift
//  EternalPieces
//
//  Created by delma on 31/07/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class JoinViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet var joinId: UITextField!
    @IBOutlet var joinPwd: UITextField!
    @IBOutlet var joinPwd2: UITextField!
    
    
    @IBOutlet var isTattist: UISwitch!
    @IBOutlet var isTattistText: UILabel!
    
 
    @IBOutlet var ttSwitch: UISwitch!
    
    
   
    
    
    override func viewDidLoad() {
        //화면 켜면 기본값 switch off 
        ttSwitch.isOn = false
        
        //화면 열리면 아이디 텍스트필드에 포커스 및 기본 키보드 영어로 세팅
        self.joinId.placeholder = "아이디"
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
        //항목 미입력시
        if self.joinId.text == "" || self.joinPwd.text == "" || self.joinPwd2.text == "" {
            
            let alert = UIAlertController(title:"Alert!", message: "항목을 모두 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default) {
                (action) in
                
            }
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
       //아이디 입력 && 비밀번호 두개 다를 경우
        }else if self.joinId.text != "" && self.joinPwd.text != self.joinPwd2.text {
            let alert = UIAlertController(title:"Alert!", message: "비밀번호가 다릅니다", preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default) {
                (action) in
                
            }
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
            
        //모든 항목 입력 && 타투어
        }else if self.joinId.text != "" && self.joinPwd.text == self.joinPwd2.text && tattistFlag == false{
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
            present(alert, animated: true, completion: nil)
            
           
            
        //모든 항목 입력 && 타투이스트
        }else if self.joinId.text != "" && self.joinPwd.text == self.joinPwd2.text && tattistFlag == true{
            if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistInfo") as? SetTattistInfoController{
                
                st.paramId = self.joinId.text!
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
