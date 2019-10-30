//
//  SetTattistInfoController.swift
//  EternalPieces
//
//  Created by delma on 01/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit

class SetTattistInfoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
  
    
 
   
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var introText: UITextView!
    @IBOutlet var adrsText: UITextField!
    
    var imgFlag = 0
    var urlString = ""
    var sendImg : UIImage!
    
    //앞 화면에서 보낸 값 받기 위한 변수
    var paramId: String = ""
    var paramPwd: String = ""
   
    
    @IBOutlet var pickBig: UIPickerView!
    @IBOutlet var pickSmall: UIPickerView!
   
    //지역 대분류 리스트
    let bigArea = ["지역을","서울", "부산", "제주"]
    let seoul = ["선택해주세요","마포구", "서대문구", "종로구"]
    let busan = ["선택해주세요","수영구", "동래구", "중구"]
    let jeju = ["선택해주세요","서귀포시", "제주시", "중구"]
    //대분류 선택 플래그
    var big: String = ""
    //선택된 항목
    var selectedBig: String = ""
    var selectedSmall: String = ""

    
    override func viewDidLoad() {
        self.introText.layer.borderWidth = 0.5
        self.introText.layer.borderColor = UIColor.gray.cgColor
        self.introText.layer.masksToBounds = true
        self.introText.layer.cornerRadius = 10.0
        
        NSLog("앞에서 받은 아이디 \(paramId)")
        NSLog("앞에서 받은 비번 \(paramPwd)"   )
        
        //pickerview
        pickBig.delegate = self
        pickBig.dataSource = self
        
        pickSmall.delegate = self
        pickSmall.dataSource = self
        

    }
    
    //이미지 첨부 버튼 선택시
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
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            self.imgView.image = img
            self.imgFlag = 1
            
            self.sendImg = img
        }

        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
    //피커뷰가 가질 목록의 길이
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          //대분류 피커뷰일경우
        if pickerView == pickBig{
            return self.bigArea.count
        }else if pickerView == pickSmall{
            return self.seoul.count
        }
        return 1
      }
      
    //피커뷰 각 행에 출력될 타이틀
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickBig {
            return self.bigArea[row]
        }else if pickerView == pickSmall && big == "서울"{
            return self.seoul[row]
        }else if pickerView == pickSmall && big == "부산"{
            return self.busan[row]
        }else if pickerView == pickSmall && big == "제주"{
            return self.jeju[row]
        }else if pickerView == pickSmall{
            return self.seoul[row]
        }
         return ""
     }
     
     //피커뷰 선택시 이벤트
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickBig && pickBig.selectedRow(inComponent: 0) == 1 {
            pickSmall.selectRow(0, inComponent: 0, animated: true)
            self.selectedBig = "서울"
            self.big = "서울"
            self.pickSmall.reloadAllComponents()
        }else if pickerView == pickBig && pickBig.selectedRow(inComponent: 0) == 2{
            pickSmall.selectRow(0, inComponent: 0, animated: true)
            self.selectedBig = "부산"
            self.big = "부산"
            self.pickSmall.reloadAllComponents()
        }else if pickerView == pickBig && pickBig.selectedRow(inComponent: 0) == 3{
            pickSmall.selectRow(0, inComponent: 0, animated: true)
            self.selectedBig = "제주"
            self.big = "제주"
            self.pickSmall.reloadAllComponents()
        }else if pickerView == pickSmall && pickBig.selectedRow(inComponent: 0) == 0{
            self.selectedSmall = self.seoul[row]
        }else if pickerView == pickSmall && pickBig.selectedRow(inComponent: 0) == 1{
            self.selectedSmall = self.busan[row]
        }else if pickerView == pickSmall && pickBig.selectedRow(inComponent: 0) == 2{
            self.selectedSmall = self.jeju[row]
        }
        
     }
    
    //확인버튼 선택시
    @IBAction func submit(_ sender: Any) {
        if self.imgView.image == nil || self.introText.text == "" || self.imgFlag == 0 || self.adrsText.text == "" || self.selectedBig == "" || self.selectedSmall == "선택해주세요"{
            let alert = UIAlertController(title:"알림", message: "항목을 모두 입력해주세요", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(ok)
            present(alert, animated: false)
            
        }else{
            if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistTime") as? SetTattistTimeController{
                
                st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                
            
                st.paramId = self.paramId
                st.paramPwd = self.paramPwd
                st.paramProfile = self.sendImg!
                st.paramIntro = self.introText.text!
                st.paramPlace = self.selectedBig + self.selectedSmall + self.adrsText.text!
                
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
