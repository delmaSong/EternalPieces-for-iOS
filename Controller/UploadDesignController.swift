//
//  UploadDesignController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher
class UploadDesignController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
 
    
    
    
    @IBOutlet var img_photo: UIImageView!       //도안 이미지
    @IBOutlet var txt_desc: UITextView!         //도안 소개
    @IBOutlet var txt_title: UITextField!       //도안 이름
    @IBOutlet var txt_size: UITextField!        //도안 사이즈
    @IBOutlet var txt_price: UITextField!       //도안 가격
    @IBOutlet var txt_spend_time: UITextField!      //예상 소요 시간
    @IBOutlet var pick_style: UIPickerView!     //도안 스타일
    
    var imgData: Data!       //서버로 넘어갈 이미지 압축 파일 변수
    var designId: Int! //도안 디테일 뷰로 넘어갈 아이디 변수
    var editFlag: Bool = false      //수정하려고 온건지 확인하는 변수. true일때 수정할 데이터 불러와야 함
    var editId: Int!        //수정할 도안이 가진 아이디
    var pickedRow: Int!     //수정시 선택된 스타일 로우 가질 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //텍스트필드 선 두께, 컬러, 굴곡 설정
        self.txt_desc.layer.borderWidth = 0.5
        self.txt_desc.layer.borderColor = UIColor.gray.cgColor
        self.txt_desc.layer.cornerRadius = 0.5
        
        //pickerView
        pick_style.delegate = self
        pick_style.dataSource = self
        
        //피커뷰 미선택시 디폴트로 가장앞에 있는거 자동 선택
        pickerView(pick_style, didSelectRow: 0, inComponent: 0)
        
        //수정하기위해 화면 들어온거라면
        if self.editFlag == true {
            
            //서버에서
            let url = "http:127.0.0.1:1234/api/upload-design/"
            let doNetwork = Alamofire.request(url+String(editId))
            //데이터 불러와서
            doNetwork.responseJSON{(response) in
                switch response.result{
                case .success(let obj):
                    if obj is NSDictionary{
                        do{
                            let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let respData = try JSONDecoder().decode(DesignVO.self, from: dataJSON)
                            //각 항목에 셋팅해준다
                            self.txt_title.text = respData.design_name
                            self.txt_size.text = (respData.design_size ?? 0).description
                            self.txt_price.text = (respData.design_price ?? 0).description
                            self.txt_spend_time.text = (respData.design_spent_time ?? 0).description
                            self.txt_desc.text = respData.design_desc
                            
                            //designId 지정
                            self.designId = self.editId!
                            
                            //kingfisher로 이미지 세팅
                            let url = "http:127.0.0.1:1234"
                            let imgURL = URL(string: url+respData.design_photo!)
                            self.img_photo.kf.setImage(with: imgURL)
                            self.imgData = try? Data(contentsOf: imgURL!)
                            
                            //기존 선택한 스타일에 맞게 피커뷰 셋팅
                            let seq = self.style_list.firstIndex(of: respData.design_style!)
                            self.pickerView(self.pick_style, didSelectRow: seq!, inComponent: 0)
                            self.pickedRow = seq!
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let e):
                    //통신 실패
                    print(e.localizedDescription)
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if editFlag {   //수정하러 들어온거면 전에 선택한 스타일대로 피커뷰 세팅
            self.pick_style.selectRow(self.pickedRow, inComponent: 0, animated: false)
        }
    }
    
    //피커뷰에 담길 스타일 분류 데이터
    var style_list = ["레터링", "수채화", "올드스쿨", "이레즈미", "블랙앤그레이", "커버업"]
    //선택된 스타일 분류
    var selected_style: String!
    
    //이미지 선택
    @IBAction func select_img(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: false)
    }
    
    //이미지 피커에서 이미지 선택하지 않았을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false)
    }
    
    //이미지 피커에서 이미지 선택 시 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false) { () in
            //이미지를 이미지 뷰에 표시
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.img_photo.image = img
            self.imgData = img?.jpegData(compressionQuality: 0.7)
        }
    }
    
    
    
    
    
    //피커뷰 컬럼 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //컴포넌트가 가질 목록의 길이
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(style_list){
            return self.style_list.count
        }
        return self.style_list.count
    }
    
    //피커뷰 각 행에 출력될 타이틀
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.style_list[row]
    }
    
    //피커뷰 선택시 이벤트
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSLog("피커뷰로 \(self.style_list[row])를 선택함 ")
        selected_style = self.style_list[row] as String
    }
    
    //피커뷰 내부 폰트사이즈 등 조절
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System Medium", size:12)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.style_list[row]
        
        return pickerLabel!
    }
    
    
    func textField( _textField:UITextField, replacementString string:String)->Bool{
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    //도안 업로드
    @IBAction func upload_design(_ sender: UIButton) {
     
        //항목 미입력시
        if self.txt_desc.text == "" || self.txt_title.text == "" || self.txt_size.text == "" || self.txt_price.text == "" || self.txt_spend_time.text == "" || imgData == nil{
            
            let alert = UIAlertController(title:"알림!", message: "항목을 모두 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default){
                (action) in
            }
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }else { //항목 모두 입력시
            let params = [
                "design_name" : self.txt_title.text!,
                "design_price" : self.txt_price.text!,
                "design_size" : self.txt_size.text!,
                "design_spent_time" : self.txt_spend_time.text!,
                "design_style" : selected_style!,
                "design_desc" : self.txt_desc.text!,
                "tatt_id" : "1111"      //로그인 기능 구현 후 수정 요망
                ] as [String : Any]
            
            var url: String!
            if editFlag == false{   //도안 업로드하기위해 들어온거면
                url = "http://127.0.0.1:1234/api/upload-design/"
                
                Alamofire.upload(multipartFormData: {multipartFormData in
                    for (key,value) in params {
                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                    multipartFormData.append(self.imgData!, withName: "design_photo", fileName: "photo.jpg", mimeType: "jpg/png")
                }, to: url!, encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON{ response in
                            debugPrint(response.result.value!)
                            if let nsDictionary = response.result.value as? NSDictionary{
                                if let id = nsDictionary["id"] as? Int{
                                    self.designId = id
                                }
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                })
                
            }else{      //editFlag == true 도안 수정하기 위한거면
                url = "http://127.0.0.1:1234/api/upload-design/" + String(editId!) + "/"
                let headers = [
                    "Content-Type" : "multipart/form-data"
                ]
                
                //서버 호출
                Alamofire.upload(multipartFormData: {multipartFormData in
                    for (key,value) in params {
                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                          multipartFormData.append(self.imgData!, withName: "design_photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                    
                }, usingThreshold: UInt64.init(), to: url!, method: .put, headers: headers) { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON{ response in
                            debugPrint(response.result.value!)  }
                    case .failure(let error):
                        print(error)
                    }//end switch
                }
            }
            
            
            let alert = UIAlertController(title: "", message: "도안 업로드가 완료되었습니다", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){
                action in
                if let st = self.storyboard?.instantiateViewController(withIdentifier: "DesignDetailView") as? DesignDetailController{
                    
                    //업로드한 도안 아이디를 다음 화면으로 전달
                    st.designId = self.designId!
                    st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                   
                    self.present(st, animated: true)
                }
            }
            alert.addAction(ok)
            self.present(alert, animated: true)
        
        
        }//else문 닫기
        
        
        
        
    }//메소드 닫기
    
    //취소
    @IBAction func go_back(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    //바깥 아무데나 누르면 키보드 사라짐
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
}



