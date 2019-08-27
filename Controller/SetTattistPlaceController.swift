//
//  SetTattistPlaceController.swift
//  EternalPieces
//
//  Created by delma on 02/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class SetTattistPlaceController: UIViewController, UITextFieldDelegate{
    
    @IBAction func submit(_ sender: Any) {
        if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistTime"){
            
            st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(st, animated: true)
        }
    }
    
    //바깥 아무데나 누르면 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func gotoSetPlace(_segue: UIStoryboardSegue){
        
    }
}
