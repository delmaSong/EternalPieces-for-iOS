//
//  SetTattistInfoController.swift
//  EternalPieces
//
//  Created by delma on 01/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class SetTattistInfoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
 
   
    @IBOutlet var imgView: UIImageView!
    //@IBOutlet var introText: UITextField!
    @IBOutlet var introText: UITextView!
    var imgFlag = 0
    var urlString = ""
    var sendImg : UIImage!
    
    //앞 화면에서 보낸 값 받기 위한 변수
    var paramId: String = ""
    var paramPwd: String = ""
   
    
    
    override func viewDidLoad() {
        self.introText.layer.borderWidth = 0.5
        self.introText.layer.borderColor = UIColor.gray.cgColor
        self.introText.layer.masksToBounds = true
        self.introText.layer.cornerRadius = 10.0
        
        NSLog("앞에서 받은 아이디 \(paramId)")
        NSLog("앞에서 받은 비번 \(paramPwd)"   )
    }
    
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        
        picker.dismiss(animated: false) { () in
            //이미지를 이미지 뷰에 표시
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = img
            self.imgFlag = 1
            
            self.sendImg = img
        }
        
//        let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
//
//
//        let imgName = imgUrl.lastPathComponent
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as! String
//        let localPath = (documentDirectory as NSString).appendingPathComponent(imgName)
//
//        let photoURL = NSURL(fileURLWithPath: localPath)
//
//        NSLog("photoURL is \(photoURL)")
//
//        self.urlString = photoURL.absoluteString!
        
    }
    
    
    @IBAction func submit(_ sender: Any) {
        if self.imgView.image == nil || self.introText.text == "" || self.imgFlag == 0 {
            let alert = UIAlertController(title:"alert", message: "항목을 모두 입력해주세요", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(ok)
            present(alert, animated: false)
            
        }else{
            if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistPlace") as? SetTattistPlaceController{
                
                st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                
            
                st.paramId = self.paramId
                st.paramPwd = self.paramPwd
//                st.paramProfile = (self.imgView.image!.pngData()?.base64EncodedString())!
                st.paramProfile = self.sendImg!
                
                st.paramIntro = self.introText.text!
                
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
