//
//  UploadWorkController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class UploadWorkController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var imgData: Data!       //서버로 넘어갈 이미지 압축 파일 변수

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var work_img: UIImageView!


  
    //업로드할 이미지 선택
    @IBAction func selectImg(_ sender: Any) {
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
              self.work_img.image = img
              self.imgData = img?.jpegData(compressionQuality: 0.7)
          }
      }
    
    //도안 업로드 버튼 클릭시
    @IBAction func upload(_ sender: Any) {
        let param = [
            "tatt_id" : "1111"
        ] as [String : Any]
        let url = "http:127.0.0.1:1234/api/works/"
        Alamofire.upload(multipartFormData: {multipartFormData in
            for (key, value) in param{
                multipartFormData.append((value as! String).data(using: .utf8)! , withName: key )
            }
            multipartFormData.append(self.imgData!, withName: "works", fileName: "photo.jpg", mimeType: "jpg/png")
        }, to: url, encodingCompletion: {encodingResult in
            switch encodingResult {
                               case .success(_):
                                   print("upload success!!")
                               case .failure(let encodingError):
                                   print(encodingError)
                               }
        })
    }
    @IBAction func cancel(_ sender: Any) {
    }
}
