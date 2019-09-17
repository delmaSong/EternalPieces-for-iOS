//
//  SetTattistPlaceController.swift
//  EternalPieces
//
//  Created by delma on 02/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class SetTattistPlaceController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var placeTxt: UITextField!
    
    let locationMgr = CLLocationManager()
    
    //앞에서 넘기는 데이터 받을 변수
    var paramId: String = ""
    var paramPwd: String = ""
    var paramProfile: String = ""
    var paramIntro: String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationMgr.delegate = self
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
//        let lat = (param?["위도"] as! NSString).doubleValue
//        let lng = (param?["경도"] as! NSString).doubleValue
//
//        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//        let regionRadius: CLLocationDistance = 100
//        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        self.map.setRegion(coordinateRegion, animted: true)
        
        //앞에서 넘긴거 잘 받는지 확인
        NSLog("프로필 세팅 화면에서 받은 아이디 \(paramId) 받은 비번 \(paramPwd) 받은 셀프 소개\(paramIntro) 받은 이미지 인코딩\(paramProfile) ")
    }
    

    


    
    @IBAction func findPlace(_ sender: Any) {
    }
    
    
    
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
    
    @IBAction func gotoSetPlace(_segue: UIStoryboardSegue){
        
    }
}
