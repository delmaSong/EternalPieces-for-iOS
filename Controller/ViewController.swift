//
//  ViewController.swift
//  EternalPieces
//
//  Created by 다0 on 16/07/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet var findStyle: UIButton!
    @IBOutlet var findTattist: UIButton!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var joinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser{  //로그인된 상태면 버튼 숨김
            loginBtn.isHidden = true
            joinBtn.isHidden = true
        }
    }

    @IBAction func gotoMain(_segue: UIStoryboardSegue){
       
    }


    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToSecondTabBar"{
            if let destVC = segue.destination as? FindTabBarController{
                destVC.selectedIndex = 1
            }
        }
    }




}

