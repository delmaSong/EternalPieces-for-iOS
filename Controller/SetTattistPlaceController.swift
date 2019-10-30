//
//  SetTattistPlaceController.swift
//  EternalPieces
//
//  Created by delma on 02/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit

class SetTattistPlaceController: UIViewController{
    
    //맵뷰
//    var mapView = MTMapView()
    
    //위치검색 옆 텍스트 입력란
    @IBOutlet var placeTxt: UITextField!
    
    
    //앞에서 넘기는 데이터 받을 변수
    var paramId: String = ""
    var paramPwd: String = ""
    var paramProfile: UIImage!
    var paramIntro: String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
//        self.mapView.frame = CGRect(x: 100, y:100, width:  self.view.frame.width, height: 50)
//        self.view.addSubview(mapView)
//        self.mapView = MTMapView(frame: self.view.bounds)
//        if let mapView = mapView as MTMapView? {
//            mapView.delegate = self
//            mapView.baseMapType = .standard
//            self.view.addSubview(mapView)
//        }
        
        //앞에서 넘긴거 잘 받는지 확인
        NSLog("프로필 세팅 화면에서 받은 아이디 \(paramId) 받은 비번 \(paramPwd) 받은 셀프 소개\(paramIntro) 받은 이미지 인코딩 \(paramProfile) ")
    }
    

    


    //찾기 버튼 클릭시
    @IBAction func findPlace(_ sender: Any) {
        //입력한 주소를 위도와 경도 값으로 변환해야 함
    }
    
    
    //확인 버튼 클릭시
    @IBAction func submit(_ sender: Any) {
        if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistTime") as? SetTattistTimeController{
            
            st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            //회원가입 위한 정보 받아서 다음 화면으로 전달
            st.paramId = self.paramId
            st.paramPwd = self.paramPwd
            st.paramProfile = self.paramProfile
            st.paramIntro = self.paramIntro
            st.paramPlace = ""      //맵뷰 구현 후 데이터 바인딩 예정
            
            self.present(st, animated: true)
        }
    }
    
    
   
    
    
    //바깥 아무데나 누르면 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //취소 버튼 클릭시
    @IBAction func gotoSetPlace(_segue: UIStoryboardSegue){
        
    }
}
