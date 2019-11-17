//
//  SettingController.swift
//  EternalPieces
//
//  Created by delma on 23/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Firebase

class SettingController: UIViewController{
    
    
    @IBOutlet var joinBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    var loginFlag = false
    
    override func viewDidLoad() {
        if let user = Auth.auth().currentUser {
           joinBtn.isHidden = true
          loginBtn.setTitle("로그아웃", for: .normal)
            loginFlag = true
       }
    }
    
    //마이페이지로 이동
    @IBAction func goMypage(_ sender: Any) {
       
    }
    
    //시술 가능 시간 설정 페이지로 이동
    @IBAction func goTimeSetting(_ sender: Any) {
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistTime") as? SetTattistTimeController{
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            lmc.editFlag = 1
            
            self.present(lmc, animated: true)
        }
    }
    //좋아요 화면으로 이동
    @IBAction func goToLike(_ sender: Any) {
        
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "LikeTabBar"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        }
    }
    
    //로그인 페이지로 이동
    @IBAction func goLogin(_ sender: Any) {
        if loginFlag {  //로그인 한 상태면
            do{
                try Auth.auth().signOut()
                loginFlag = false
                let alert = UIAlertController(title:"알림", message: "로그아웃 되었습니다", preferredStyle: .alert)
                let ok = UIAlertAction(title:"확인", style: .default){
                    (action) in
                    if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as? ViewController{
                                       lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                                       self.present(lmc, animated: true)
                                   }
                }
                alert.addAction(ok)
                self.present(alert, animated: true)
            }catch let e as NSError {
                print(e.localizedDescription)
            }
        }else { //로그인 안한 상태면
            if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "LoginScene") as? LoginController{
                lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                self.present(lmc, animated: true)
            }
        }
    }
    //회원가입 페이지로 이동
    @IBAction func goJoin(_ sender: Any) {
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "JoinView") as? JoinViewController{
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        }
    }
    
    //세그로 연결한 다른 화면에서 뒤로 돌아올때
    @IBAction func gotoSetting(_segue: UIStoryboardSegue){
        
    }
}
