//
//  PayController.swift
//  EternalPieces
//
//  Created by delma on 17/10/2019.
//  Copyright © 2019 다0. All rights reserved.
//  결제화면 컨트롤러

import UIKit
import Alamofire
import Kingfisher

class PayController: UIViewController{
    
    //앞에서 넘기는 예약정보 받을 변수
    var selectedDate = ""       //선택한 날짜
    var bodyPart = ""           //부위
    var selectedSize = ""       //선택한 사이즈
    var selectedTime = ""       //선택한 시간
    var designURL = ""          //이미지 url string
    var tattId = ""             //타티스트 아이디
    var tattPlace = ""          //작업장 주소
    var payPrice = ""           //결제할 금액
    var designId = ""
    
    
    @IBOutlet var img: UIImageView!     //시술이미지
    @IBOutlet var booker: UILabel!      //예약자 아이디
    @IBOutlet var book_comm: UITextView!        //예약 요청사항
    @IBOutlet var book_date: UILabel!           //시술일시
    @IBOutlet var book_part: UILabel!           //시술부위
    @IBOutlet var book_size: UILabel!          //시술사이즈
    @IBOutlet var book_tatt: UILabel!           //타티스트
    @IBOutlet var book_place: UILabel!          //시술장소
    @IBOutlet var book_price: UILabel!          //시술가격
    
    @IBOutlet var pay_switch: UISwitch!
    @IBOutlet var pay_way: UILabel!     //결제방식
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //텍스트필드 선, 두께, 컬러, 굴곡 설정
        self.book_comm.layer.borderWidth = 0.5
        self.book_comm.layer.borderColor = UIColor.gray.cgColor
        self.book_comm.layer.cornerRadius = 0.5
        
        //결제방식 디폴트값 무통장
        pay_switch.isOn = true
        
        self.booker.text = "2222"       //로그인한 유저 아이디로 값 넣어주기
        self.book_part.text = self.bodyPart
        self.book_size.text = self.selectedSize
        self.book_date.text = self.selectedDate + self.selectedTime
        self.book_place.text = self.tattPlace
        self.book_price.text = self.payPrice
        self.book_tatt.text = self.tattId
        
        //이미지 세팅
        let url = "http:127.0.0.1:1234"
        let imgURL = URL(string: url+self.designURL)
        self.img.kf.setImage(with: imgURL)
    }
    
    //결제수단 스위치버튼
    @IBAction func selectPayMethod(_ sender: UISwitch) {
        if sender.isOn{
            self.pay_way.text = "무통장입금"
        }else{
            self.pay_way.text = "카드결제"
        }
    }
    
    
    
    
    //결제하기 버튼. 서버 호출
    @IBAction func doPay(_ sender: Any) {
        let alert = UIAlertController(title: "결제하시겠습니까?", message: "", preferredStyle: .alert)
        let defualtAction = UIAlertAction(title: "확인", style: .default){
            (action) in
            let params = [
                       "booker" : "2222",
                       "book_date" : self.selectedDate,
                       "book_time" : self.selectedTime,
                       "book_price" : self.payPrice,
                       "book_part" : self.bodyPart,
                       "book_size" : self.selectedSize,
                       "book_comm" : self.book_comm.text!,
                       "book_photo" : self.designURL,
                       "book_tatt" : self.tattId,
                       "book_place" : self.tattPlace,
                       "design_id" : self.designId
                   ] as [String : Any]
            
                   let url = "http://127.0.0.1:1234/api/booking/"
                   Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            
                let alert = UIAlertController(title: "예약이 완료되었습니다", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default){
                    (action) in
                    if let st = self.storyboard?.instantiateViewController(withIdentifier: "FindStyle") as? FindStyleViewController{
                    
                    st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                    self.present(st, animated: true)

                    }
                }
            alert.addAction(action)
            self.present(alert, animated:true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(defualtAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
   }
    
    //바깥 아무데나 누르면 키보드 사라짐
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    
}
