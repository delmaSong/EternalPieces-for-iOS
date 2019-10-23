//
//  SetTattistTimeController.swift
//  EternalPieces
//
//  Created by delma on 02/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SetTattistTimeController: UIViewController{
    
    //수정하기 위해 들어온지 구분하는 플래그 1일때 수정
    var editFlag : Int = 0
    
    //앞에서 넘기는 데이터 받을 변수
    var paramId: String = ""
    var paramPwd: String = ""
    var paramProfile: UIImage!
    var paramIntro: String = ""
    var paramPlace: String = ""
    
    var availableDay = Array<String>()
    var availableTime = Array<String>()
    
    @IBOutlet var mon: UISwitch!
    @IBOutlet var tue: UISwitch!
    @IBOutlet var wed: UISwitch!
    @IBOutlet var thu: UISwitch!
    @IBOutlet var fri: UISwitch!
    @IBOutlet var sat: UISwitch!
    @IBOutlet var sun: UISwitch!
    
    
    @IBOutlet var eleven: UISwitch!
    @IBOutlet var twelve: UISwitch!
    @IBOutlet var thirdteen: UISwitch!
    
    
    @IBOutlet var fourteen: UISwitch!
    @IBOutlet var fifteen: UISwitch!
    @IBOutlet var sixteen: UISwitch!
    
    @IBOutlet var seventeen: UISwitch!
    @IBOutlet var eighteen: UISwitch!
    @IBOutlet var nineteen: UISwitch!
    
    @IBOutlet var twenty: UISwitch!
    @IBOutlet var twentyOne: UISwitch!
    @IBOutlet var twentyTwo: UISwitch!
    
    //타티스트가 이전에 설정했던 요일과 시간
    var selectedDate: String = ""
    var selectedTime: String = ""
    
    override func viewDidLoad() {
      print("self.editFlag is \(self.editFlag)")
        
        //수정하기위해 화면 들어온거라면
        if self.editFlag == 1{
            //서버에서
            let url = "http:127.0.0.1:1234/api/join_api/"
            let doNetwork = Alamofire.request(url+"3")   //뒤 번호 타티스트 고유 아이디값 변수로 세팅해주기
            doNetwork.responseJSON{(response) in
                switch response.result{
                case .success(let obj):
                    
                    if obj is NSDictionary{
                        do{
                            let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let respData = try JSONDecoder().decode(FindTattistVO.self, from: dataJSON)
                            self.selectedDate = respData.tatt_date!
                            self.selectedTime = respData.tatt_time!
                            print("self.selectedDate is \(self.selectedDate)")
                            print("self.selectedTime is \(self.selectedTime)")
                        }catch{
                            print(error.localizedDescription)
                        }
                    }

                            //기존 값 기반으로 스위치 세팅해줌
                            if self.selectedDate.contains("월")  {self.mon.isOn = true; self.availableDay.append("월")}else{self.mon.isOn = false}
                           if self.selectedDate.contains("화")  {self.tue.isOn = true; self.availableDay.append("화")}else{self.tue.isOn = false}
                           if self.selectedDate.contains("수")  {self.wed.isOn = true; self.availableDay.append("수")}else{self.wed.isOn = false}
                           if self.selectedDate.contains("목")  {self.thu.isOn = true; self.availableDay.append("목")}else{self.thu.isOn = false}
                           if self.selectedDate.contains("금")  {self.fri.isOn = true; self.availableDay.append("금")}else{self.fri.isOn = false}
                           if self.selectedDate.contains("토")  {self.sat.isOn = true; self.availableDay.append("토")}else{self.sat.isOn = false}
                           if self.selectedDate.contains("일")  {self.sun.isOn = true; self.availableDay.append("일")}else{self.sun.isOn = false}


                            if self.selectedTime.contains("11시")  {self.eleven.isOn = true; self.availableTime.append("11시")}else{self.eleven.isOn = false}
                           if self.selectedTime.contains("12시")  {self.twelve.isOn = true; self.availableTime.append("12시")}else{self.twelve.isOn = false}
                           if self.selectedTime.contains("13시")  {self.thirdteen.isOn = true; self.availableTime.append("13시")}else{self.thirdteen.isOn = false}

                           if self.selectedTime.contains("14시")  {self.fourteen.isOn = true; self.availableTime.append("14시")}else{self.fourteen.isOn = false}
                           if self.selectedTime.contains("15시")  {self.fifteen.isOn = true; self.availableTime.append("15시")}else{self.fifteen.isOn = false}
                           if self.selectedTime.contains("16시")  {self.sixteen.isOn = true; self.availableTime.append("16시")}else{self.sixteen.isOn = false}

                           if self.selectedTime.contains("17시")  {self.seventeen.isOn = true; self.availableTime.append("17시")}else{self.seventeen.isOn = false}
                           if self.selectedTime.contains("18시")  {self.eighteen.isOn = true; self.availableTime.append("18시")}else{self.eighteen.isOn = false}
                           if self.selectedTime.contains("19시")  {self.nineteen.isOn = true; self.availableTime.append("19시")}else{self.nineteen.isOn = false}

                           if self.selectedTime.contains("20시")  {self.twenty.isOn = true; self.availableTime.append("20시")}else{self.twenty.isOn = false}
                           if self.selectedTime.contains("21시")  {self.twentyOne.isOn = true; self.availableTime.append("21시")}else{self.twentyOne.isOn = false}
                           if self.selectedTime.contains("22시")  {self.twentyTwo.isOn = true; self.availableTime.append("22시")}else{self.twentyTwo.isOn = false}

                case .failure(let e):       //통신 실패
                    print(e.localizedDescription)
                }
            }


        }else{
            mon.isOn = false
          tue.isOn = false
          wed.isOn = false
          thu.isOn = false
          fri.isOn = false
          sat.isOn = false
          sun.isOn = false
          
          eleven.isOn = false
          twelve.isOn = false
          thirdteen.isOn = false
          
          fourteen.isOn = false
          fifteen.isOn = false
          sixteen.isOn = false
          
          seventeen.isOn = false
          eighteen.isOn = false
          nineteen.isOn = false
          
          twenty.isOn = false
          twentyOne.isOn = false
          twentyTwo.isOn = false
        }
    }
    
    
    @IBAction func onMon(_ sender: UISwitch) {
        if sender.isOn{
            availableDay.append("월")
        }else{
            availableDay = availableDay.filter{$0 != "월"}
        }
    }
    
    @IBAction func onTue(_ sender: UISwitch) {
        if sender.isOn{
            availableDay.append("화")
        }else{
            availableDay = availableDay.filter{$0 != "화"}
        }
    }
    
    @IBAction func onWed(_ sender: UISwitch) {
        if sender.isOn{
            availableDay.append("수")
        }else{
            availableDay = availableDay.filter{$0 != "수"}
        }
    }
    
    @IBAction func onThu(_ sender: UISwitch) {
        if sender.isOn{
            availableDay.append("목")
        }else{
            availableDay = availableDay.filter{$0 != "목"}
        }
    }
    
    
    
    @IBAction func onFri(_ sender: UISwitch) {
        if sender.isOn{
            availableDay.append("금")
        }else{
            availableDay = availableDay.filter{$0 != "금"}
        }
    }

    @IBAction func onSat(_ sender: UISwitch) {
        if sender.isOn{
            availableDay.append("토")
        }else{
            availableDay = availableDay.filter{$0 != "토"}
        }
    }
    
    @IBAction func onSun(_ sender: UISwitch) {
        if sender.isOn{
            availableDay.append("일")
        }else{
            availableDay = availableDay.filter{$0 != "일"}
        }
    }
    
    
    
    
    
    
    
    @IBAction func on11(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("11시")
        }else{
            availableTime = availableTime.filter{$0 != "11시"}
        }
    }
    
    
    @IBAction func on12(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("12시")
        }else{
            availableTime = availableTime.filter{$0 != "12시"}
        }
    }
    
    
    @IBAction func on13(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("13시")
        }else{
            availableTime = availableTime.filter{$0 != "13시"}
        }
    }
    
    
    
    
    
    @IBAction func on14(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("14시")
        }else{
            availableTime = availableTime.filter{$0 != "14시"}
        }
    }
    
    @IBAction func on15(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("15시")
        }else{
            availableTime = availableTime.filter{$0 != "15시"}
        }
    }
    
    @IBAction func on16(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("16시")
        }else{
            availableTime = availableTime.filter{$0 != "16시"}
        }
    }
    
    
    
    
    
    @IBAction func on17(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("17시")
        }else{
            availableTime = availableTime.filter{$0 != "17시"}
        }
    }
    
    
    @IBAction func on18(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("18시")
        }else{
            availableTime = availableTime.filter{$0 != "18시"}
        }
    }
    
    
    @IBAction func on19(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("19시")
        }else{
            availableTime = availableTime.filter{$0 != "19시"}
        }
    }
    
    
    
    
    @IBAction func on20(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("20시")
        }else{
            availableTime = availableTime.filter{$0 != "20시"}
        }
    }
    
    @IBAction func on21(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("21시")
        }else{
            availableTime = availableTime.filter{$0 != "21시"}
        }
    }
    
    @IBAction func on22(_ sender: UISwitch) {
        if sender.isOn{
            availableTime.append("22시")
        }else{
            availableTime = availableTime.filter{$0 != "22시"}
        }
    }
    
    
    
    
    
    
    @IBAction func submit(_ sender: Any) {
        
        let message: String = "\(availableDay) \n \(availableTime)"


            //설정확인 알럿창
            let alert = UIAlertController(title:"설정이 맞으면 \n 확인 버튼을 눌러주세요", message: message, preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let ok = UIAlertAction(title: "확인", style: .default) { (action) in
                
                var times:String = ""
                for a in self.availableTime{times += a}
                var days:String = ""
                for b in self.availableDay {days += b}
                
                //시술 가능 시간 수정하는거라면
                if self.editFlag == 1 {
                    let params = [ "tatt_time" : times, "tatt_date" : days ]
                    let url = "http://127.0.0.1:1234/api/join_api/"
                    Alamofire.request(url+"3", method: .put, parameters: params, encoding: JSONEncoding.default)
                }else{  //회원가입이라면

                               //user 테이블에 insert
                               let join_param = [
                                   "user_id" : self.paramId,
                                   "user_pw" : self.paramPwd,
                                   "role_tatt" : true
                                   ] as [String : Any]
                               
                               let join_url = "http://127.0.0.1:1234/api/login_api/"
                                Alamofire.request(join_url, method: .post, parameters: join_param, encoding: JSONEncoding.default)
                               let param = [
                                   "tatt_time" : times,
                                  "tatt_id" : self.paramId,
                                  "tatt_date" : days,
                                  "tatt_work" : "hi",
                                  "tatt_addr" : "hi",
                                  "tatt_intro" : self.paramIntro,
                                   ] as [String : Any]
                    
                               let imgData = self.paramProfile.jpegData(compressionQuality: 0.7)
                               
                               //API 호출
                             
                               let url = "http://127.0.0.1:1234/api/join_api/"
                               Alamofire.upload(multipartFormData: { multipartFormData in
                                   for (key,value) in param {
                                       multipartFormData.append((value as! String).data(using: .utf8)!, withName:key)}
                                   multipartFormData.append(imgData!, withName: "tatt_profile",fileName: "photo.jpg", mimeType: "jpg/png")
                               }, to: url, encodingCompletion: { encodingResult in
                                   switch encodingResult {
                                   case .success(let upload, _, _):
                                       upload.responseJSON{ response in debugPrint(response)}
                                   case .failure(let encodingError):
                                       print(encodingError)
                                   }
                               } )//alamofire 닫음
                               
                            
                               //완료 알림
                               let alert2 = UIAlertController(title:"", message:"회원가입이 완료되었습니다", preferredStyle: .alert)
                               
                               let ok2 = UIAlertAction(title: "확인", style: .default){ action in
                                   if let st = self.storyboard?.instantiateViewController(withIdentifier: "LoginScene"){
                                       st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                                       self.present(st, animated: true)
                                   }
                               }   //ok2
                               alert2.addAction(ok2)
                               self.present(alert2, animated: true)
                }//if
                
            }   //ok
            
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
