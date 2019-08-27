//
//  SetTattistInfoController.swift
//  EternalPieces
//
//  Created by delma on 01/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class SetTattistInfoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
 
   
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var introText: UITextField!
    
    @IBAction func pickImg(_ sender: Any) {
        
        //이미지 피커 컨트롤러 인스턴스 생성
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        //델리게이트 지정
        picker.delegate = self
        
        //이미지 피커 컨트롤러 실행
        self.present(picker, animated: false)
    }
    
    //이미지 피커에서 이미지 선택하지 않고 취소했을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: false)
    }
    
    //이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: false) { () in
            //이미지를 이미지 뷰에 표시
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = img
        }
    }
    
    
    @IBAction func submit(_ sender: Any) {
        if self.imgView.image == nil || self.introText.text == "" {
            let alert = UIAlertController(title:"alert", message: "항목을 모두 입력해주세요", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(ok)
            present(alert, animated: false)
            
        }else{
            if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistPlace"){
                
                st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                
                self.present(st, animated: true)
            }
        }
        
    }
    
    //바깥 아무데나 누르면 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func gotoSetInfo(_segue: UIStoryboardSegue){
        
    }
    
    
}
