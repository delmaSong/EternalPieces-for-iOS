//
//  UploadReviewController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import Alamofire

class UploadReviewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet var reviewTitle: UITextField!    //제목
    @IBOutlet var contents: UITextView!     //내용
    @IBOutlet var imgView: UIImageView!

    let stars = CosmosView()        //rating bar
    let colorli = #colorLiteral(red: 0.394319929, green: 0.536441238, blue: 0.6976721129, alpha: 1)
    var imgData: Data!          //이미지 압축파일 변수
    var tId: String = ""        //tattist id
    var rating: Double = 0
    
    //수정하러 들어왔을 시 필요한 데이터
    var editFlag: Int = 0       //1이면 수정
    var rId: Int = 0
    
    override func viewDidLoad() {
        self.contents.layer.borderWidth = 0.5
        self.contents.layer.borderColor = UIColor.gray.cgColor
        
        //별점바
        self.stars.frame = CGRect(x: 150, y: (self.view.frame.height/2 - 50) , width: 100, height: 50)
        self.stars.settings.fillMode = .half        //0.5단위
        self.stars.settings.emptyBorderColor = colorli  //색상 결정
        self.stars.settings.filledColor = colorli
        self.stars.settings.filledBorderColor = colorli
        self.stars.rating = 0               //미선택시 기본값 0
        self.view.addSubview(stars)
        
        self.stars.didTouchCosmos = { rating in
            self.rating = rating
        }
        
        if editFlag == 0 {      //새롭게 작성하러 들어왔을 시
            NotificationCenter.default.addObserver(self, selector: #selector(getDId), name: .getDId, object: nil)
        }else {     //수정하러 왔을 시
            let url = "http:127.0.0.1:1234/api/review/"
            let doNetwork = Alamofire.request(url+String(self.rId))
            doNetwork.responseJSON{(response) in
                switch response.result{
                case .success(let obj):
                    if obj is NSDictionary{
                       do{
                           let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                           let respData = try  JSONDecoder().decode(TattistWithReviewVO.self, from: dataJSON)
                           //각 항목에 셋팅해준다
                        self.reviewTitle.text = respData.rv_title!
                        self.contents.text = respData.rv_contents!
                        self.stars.rating = Double(respData.rv_rate!)!
                        self.tId = respData.rv_tatt!

                           
                       //kingfisher로 이미지 세팅
                        let url = "http:127.0.0.1:1234"
                        let imgURL = URL(string: url+respData.rv_photo!)
                        self.imgView.kf.setImage(with: imgURL)
                        self.imgData = try? Data(contentsOf: imgURL!)
                           
 
                       }catch{
                           print(error.localizedDescription)
                       }
                   }
                case .failure(let e):
                    print(e.localizedDescription)
                }
            }
        }
        
        
    }
    
    @objc func getDId(_ notification: Notification){
        //앞에서 보내준 타티스트id 받음
        self.tId = notification.object as! String
        print("앞에서 보낸 타티스트 아이디 는 \(self.tId)")
    }
    
    @IBAction func addImg(_ sender: UIButton) {
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
                self.imgView.image = img
                self.imgData = img?.jpegData(compressionQuality: 0.7)
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
    }
    
    //리뷰 업로드
    @IBAction func upload(_ sender: UIButton) {
        //제목 or 내용 미입력시
        if self.reviewTitle.text == "" || self.contents.text == "" {
            let alert = UIAlertController(title:"알림!", message: "항목을 모두 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                       let defaultAction = UIAlertAction(title: "OK", style: .default){
                           (action) in
                       }
                       alert.addAction(defaultAction)
                       present(alert, animated: true, completion: nil)
        }else {
            let params = [
                "rv_writer" : "fff",        //현재 로그인한 사용자로 변경필요
                "rv_title" : self.reviewTitle.text!,
                "rv_contents" : self.contents.text!,
                "rv_rate" : String(format:"%.1f", self.rating),
                "rv_tatt" : self.tId
            ] as [String : Any]
         
        var url = "http:127.0.0.1:1234/api/review/"
            
        if editFlag == 0 {      //리뷰 새로 업로드라면
                Alamofire.upload(multipartFormData: {multipartFormData in
                    for (key,value) in params {
                            multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                    if self.imgData != nil{
                        multipartFormData.append(self.imgData!, withName: "rv_photo", fileName: "photo.jpg", mimeType: "jpg/png")
                    }
                }, to: url, encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON{ response in
                            debugPrint(response.result.value!) }
                        //화면이동
                           if let st = self.storyboard?.instantiateViewController(withIdentifier: "SettingView") as? SettingController{
                           st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                           self.present(st, animated: true) }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                })
            }else {      //리뷰 수정이라면
            url = url + String(self.rId) + "/"
            let headers = [ "Content-Type" : "multipart/form-data" ]

            //서버 호출
            Alamofire.upload(multipartFormData: {multipartFormData in
                for (key,value) in params {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
                      multipartFormData.append(self.imgData!, withName: "rv_photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                
            }, usingThreshold: UInt64.init(), to: url, method: .put, headers: headers) { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
                        debugPrint(response.result.value!)  }
                case .failure(let error):
                    print(error)
                }//end switch
            }
        
        }
        let alert = UIAlertController(title: "", message: "리뷰 업로드가 완료되었습니다", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default){
            action in
//            if let st = self.storyboard?.instantiateViewController(withIdentifier: "DesignDetailView") as? DesignDetailController{
//
//                //업로드한 도안 아이디를 다음 화면으로 전달
//                st.designId = self.designId!
//                st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//
//                self.present(st, animated: true)
            self.dismiss(animated: true)
            }

        alert.addAction(ok)
        self.present(alert, animated: true)
    
        }
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .getDId, object: nil)
    }
}
