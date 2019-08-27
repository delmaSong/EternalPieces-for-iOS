//
//  SetTattistTimeController.swift
//  EternalPieces
//
//  Created by delma on 02/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class SetTattistTimeController: UIViewController{
    
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
    
    
    override func viewDidLoad() {
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
       
        let alert = UIAlertController(title:"설정이 맞으면 \n 확인 버튼을 눌러주세요", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) {
            (action) in
            
            let alert2 = UIAlertController(title:"", message:"회원가입이 완료되었습니다", preferredStyle: .alert)
            
            let ok2 = UIAlertAction(title: "확인", style: .default){
                action in
                if let st = self.storyboard?.instantiateViewController(withIdentifier: "LoginScene"){
                    
                    st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                    
                    self.present(st, animated: true)
            }
            
           
            }
            alert2.addAction(ok2)
            self.present(alert2, animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
