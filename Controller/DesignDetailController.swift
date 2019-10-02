//
//  DesignDetailController.swift
//  EternalPieces
//
//  Created by delma on 11/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class DesignDetailController: UIViewController {
    
    
    //상단에 보이는 타티스트 아이디
    @IBOutlet var tattistId1: UILabel!
    //중앙에 담기는 타티스트 아이디
    @IBOutlet var tattistId2: UILabel!
    //도안 이미지
    @IBOutlet var design: UIImageView!
    //타티스트 프로필 이미지
    @IBOutlet var profile: UIImageView!
    //도안 이름
    @IBOutlet var designName: UILabel!
    //도안 기준 사이즈
    @IBOutlet var size: UILabel!
    //도안 가격
    @IBOutlet var price: UILabel!
    //소요 시간
    @IBOutlet var spentTime: UILabel!
    //디자인 간단 소개
    @IBOutlet var design_desc: UITextView!
    
    //앞에서 보내는 도안 아이디 받을 변수
    var designId: Int = 0
    
    //도안 업로드에서 들어오는건지, 스타일찾기에서 들어오는건지에 따라 분기해줄 필요 있음 
    override func viewDidLoad() {
       super.viewDidLoad()
        print("designId is \(designId)")
        let url = "http:127.0.0.1:1234/api/upload-design/"
        let doNetwork = Alamofire.request(url+String(designId))
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                if obj is NSDictionary{
                    //통신 성공
                    do{
                        //obj(Any)를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        let respData = try JSONDecoder().decode(DesignVO.self, from: dataJSON)
                       
                        //데이터 적용
                        self.tattistId1.text = respData.tatt_id
                        self.tattistId2.text = respData.tatt_id
                        self.designName.text = respData.design_name
                        self.size.text = (respData.design_size ?? 0).description
                        self.price.text = (respData.design_price ?? 0).description
                        self.spentTime.text = (respData.design_spent_time ?? 0).description
                        self.design_desc.text = respData.design_desc
                        
                        //kingfisher 이용해 이미지 불러와서 적용
                        let url = "http:127.0.0.1:1234"
                        let imgURL = URL(string: url+respData.design_photo!)
                        self.design.kf.setImage(with: imgURL)
                        
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
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}



