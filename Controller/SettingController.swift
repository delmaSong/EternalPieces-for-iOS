//
//  SettingController.swift
//  EternalPieces
//
//  Created by delma on 23/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class SettingController: UIViewController{
    
    
    
    @IBAction func goToLike(_ sender: Any) {
        
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "LikeTabBar"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        }
    }
    
    @IBAction func gotoSetting(_segue: UIStoryboardSegue){
        
    }
}
