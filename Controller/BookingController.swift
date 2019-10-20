//
//  BookingController.swift
//  EternalPieces
//
//  Created by delma on 17/10/2019.
//  Copyright © 2019 다0. All rights reserved.
// 예약화면 컨트롤러

import UIKit
import Alamofire
import Kingfisher

class BookingController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
  
    //시간 선택 컬렉션뷰
    @IBOutlet var collectionView: UICollectionView!
    
    //선택된 날짜 담을 라벨
    @IBOutlet var selectedDate: UILabel!
  
    //월요일
    @IBOutlet var mon: UIButton!
    //화요일
    @IBOutlet var tue: UIButton!
    //수요일
    @IBOutlet var wed: UIButton!
    //목요일
    @IBOutlet var thu: UIButton!
    //금요일
    @IBOutlet var fri: UIButton!
    //토요일
    @IBOutlet var sat: UIButton!
    //일요일
    @IBOutlet var sun: UIButton!
    
    //예약할 도안
    @IBOutlet var selectedDesign: UIImageView!
    //예약할 도안 이름
    @IBOutlet var designName: UILabel!
    //도안 가격
    @IBOutlet var designPrice: UILabel!
    //도안 사이즈
    @IBOutlet var designSize: UILabel!
    //예상 소요 시간
    @IBOutlet var spendTime: UILabel!
    
    
    //시술부위 선택 피커뷰
    @IBOutlet var pickBodyPart: UIPickerView!
    //피커뷰로 선택한 부위
    var selectedBodyPart = ""
    
    //사이즈 선택 피커뷰
    @IBOutlet var pickSize: UIPickerView!
    //피커뷰로 선택한 사이즈
    var selectedSize = ""
    
    

    
    
    //도안 아이디값 넘겨받을 변수
    var designNum : Int = 0
    //타티스트가 가능하다고 한 시간대 담을 배열
    var timeArray: [String] = []
    //타티스트가 가능하다고 한 시간대 담을 변수
    var timeTxt = ""
    //타티스트가 가능하다고 한 요일 담을 변수
    var dateTxt = ""
    //타티스트 아이디 담을 변수 =>이걸로 타티스트 정보 가져옴
    var tattId = ""
    //컬렉션뷰에 넣어줄 데이터 리스트
    var list: [FindTattistVO] = []
   
    
    //selectedBodyPart 피커뷰에 담길 데이터
    var bodyPartList = ["팔 상단", "팔 하단", "허벅지", "종아리", "손", "발", "목", "등", "기타 부위"]
    
    //selectSize 피커뷰에 담길 데이터
    var sizeList = ["~3cm", "4~6cm", "7~9cm", "10~12cm", "13~15cm", "15cm 이상"]
    
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pickBodyPart.dataSource = self
        pickBodyPart.delegate = self
        
        pickSize.dataSource = self
        pickSize.delegate = self
        
        
        
        //피커뷰 미선택시 디폴트로 가장 앞에 있는거 자동 선택
        pickerView(pickBodyPart, didSelectRow: 0, inComponent: 0)
        pickerView(pickSize, didSelectRow: 0, inComponent: 0)
        
        //이번주 월요일 날짜 가져옴
        setDate(date:now)
        
        //도안데이터 세팅
        getDesignData()
        //타티스트 데이터 세팅
        getTattistData()
        
        
        
    }
    

    
    //오늘 날짜
    var stdWeek = Date()
    let now = Date()
    
    //이번주 월요일 기반으로 들어갈 값 계산
    func setDate(date:Date){
           //날짜 형식 세팅
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd"

           //오늘을 기반으로 날짜 값 가져오기
           var cal = Calendar(identifier: .gregorian)
           cal.firstWeekday = 2        //주의 시작을 월요일로

           let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)        //이번주를 가져옴
           let startOfWeek = cal.date(from: comps)     //이번주의 시작날짜인 월요일의 (연-월-일 시)형식
           let thisTue = startOfWeek! + 86400          //월요일을 기반으로 그 다음날 값
           let thisWed = thisTue + 86400               //그 다음날 ..
           let thisThu = thisWed + 86400
           let thisFri = thisThu + 86400
           let thisSat = thisFri + 86400
           let thisSun = thisSat + 86400
           
           
           //각 요일 버튼에 "dd"형식으로 값 세팅
           self.mon.setTitle(dateFormatter.string(from: startOfWeek!), for: .normal)
           self.tue.setTitle(dateFormatter.string(from: thisTue), for: .normal)
           self.wed.setTitle(dateFormatter.string(from: thisWed), for: .normal)
           self.thu.setTitle(dateFormatter.string(from: thisThu), for: .normal)
           self.fri.setTitle(dateFormatter.string(from: thisFri), for: .normal)
           self.sat.setTitle(dateFormatter.string(from: thisSat), for: .normal)
           self.sun.setTitle(dateFormatter.string(from: thisSun), for: .normal)
   
       
        //현재 기준 과거일경우 버튼 선택 불가
        //월요일 버튼
        if now.timeIntervalSince(startOfWeek!) >= 0 || !self.dateTxt.contains("월"){
            self.mon.isEnabled = false
            self.mon.setTitleColor(.gray, for: .normal)
        }else{
            self.mon.isEnabled = true
            self.mon.setTitleColor(.black, for: .normal)
        }
        
        //화요일
        if now.timeIntervalSince(thisTue) >= 0 || !self.dateTxt.contains("화"){
            self.tue.isEnabled = false
            self.tue.setTitleColor(.gray, for: .normal)
        }else{
            self.tue.isEnabled = true
            self.tue.setTitleColor(.black, for: .normal)
        }
        //수요일
        if now.timeIntervalSince(thisTue) >= 0 || !self.dateTxt.contains("수"){
            self.wed.isEnabled = false
            self.wed.setTitleColor(.gray, for: .normal)
        }else{
            self.wed.isEnabled = true
            self.wed.setTitleColor(.black, for: .normal)
        }
        //목요일
        if now.timeIntervalSince(thisTue) >= 0 || !self.dateTxt.contains("목"){
            self.thu.isEnabled = false
            self.thu.setTitleColor(.gray, for: .normal)
        }else{
            self.thu.isEnabled = true
            self.thu.setTitleColor(.black, for: .normal)
        }
        //금요일
        if now.timeIntervalSince(thisTue) >= 0 || !self.dateTxt.contains("금"){
            self.fri.isEnabled = false
            self.fri.setTitleColor(.gray, for: .normal)
        }else{
            self.fri.isEnabled = true
            self.fri.setTitleColor(.black, for: .normal)
        }
        //토요일
        if now.timeIntervalSince(thisTue) >= 0 || !self.dateTxt.contains("토"){
            self.sat.isEnabled = false
            self.sat.setTitleColor(.gray, for: .normal)
        }else{
            self.sat.isEnabled = true
            self.sat.setTitleColor(.black, for: .normal)
        }
        //일요일
        if now.timeIntervalSince(thisTue) >= 0 || !self.dateTxt.contains("일"){
            self.sun.isEnabled = false
            self.sun.setTitleColor(.gray, for: .normal)
        }else{
            self.sun.isEnabled = true
            self.sun.setTitleColor(.black, for: .normal)
        }

       }
       
    
    //이전주, 다음주 버튼 이동 확인 플래그
    var mvFlag: Int = 0
    
    
    //이전주로 날짜 이동 버튼
    @IBAction func mvBefore(_ sender: Any) {
        //현재 날짜로부터 이전날짜로는 이동 불가.
        if mvFlag > 0 {
            mvFlag-=1
            self.stdWeek = stdWeek - 604800
            setDate(date: stdWeek)
        }
    }
    
    //다음주로 날짜 이동 버튼
    @IBAction func mvAfter(_ sender: Any) {
        //mvFlag가 4 이하일때만 변동 있음. 현재 날짜로부터 앞으로 4주간만 예약 가능
        if mvFlag < 5 {
            mvFlag += 1
            self.stdWeek = stdWeek + 604800
            setDate(date: stdWeek)
        }
    }
    
    
    
    //월요일 선택
    @IBAction func selectMon(_ sender: Any) {
//        self.selectedDate!.text =
    }
    //화요일 선택
    @IBAction func selectTue(_ sender: Any) {
    }
    //수요일 선택
    @IBAction func selectWed(_ sender: Any) {
    }
    //목요일 선택
    @IBAction func selectThu(_ sender: Any) {
    }
    //금요일 선택
    @IBAction func selectFri(_ sender: Any) {
    }
    //토요일 선택
    @IBAction func selectSat(_ sender: Any) {
    }
    //일요일 선택
    @IBAction func selectSun(_ sender: Any) {
    }
    
    
    
    
    //예약하기 버튼. 결제창으로 이동
    @IBAction func doBook(_ sender: Any) {
    }
    
    
    //뒤로가기 버튼
    @IBAction func goBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)

    }
    
    
   

      
    
    //서버에서 디자인 데이터 가져오기
    func getDesignData(){
        let url = "http:127.0.0.1:1234/api/upload-design/"+String(self.designNum)
        let doNetwork = Alamofire.request(url)
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj): //통신 성공
                if obj is NSDictionary{
                    do{
                        //obj(Any)를 JSON으로 변경
                       let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                       let respData = try JSONDecoder().decode(DesignVO.self, from: dataJSON)
                        
                        //데이터 적용
                        self.designPrice.text! = (respData.design_price ?? 0).description //가격
                        self.designSize.text! = (respData.design_size ?? 0).description    //사이즈
                        self.spendTime.text! = (respData.design_spent_time ?? 0).description   //예상소요시간
                        self.designName.text = respData.design_name     //도안 이름

                        //이미지 데이터 적용
                        let url = "http:127.0.0.1:1234"
                        let imgURL = URL(string: url+respData.design_photo!)
                        self.selectedDesign.kf.setImage(with: imgURL)
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                    print("design obj is \(obj)")

                }

            case .failure(let e):   //통신 실패
                print(e.localizedDescription)
            }
        }
    }
    
    //서버에서 타티스트 데이터 가져오기
    func getTattistData(){
        let url = "http:127.0.0.1:1234/api/join_api/?tatt_id="+self.tattId
        let doNetwork = Alamofire.request(url)
        print("getTatttData url is \(url)")
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj): //통신 성공
                print("통신 성공~~~~~~~~₩")

                if let nsArray = obj as? NSArray{
                    
                    for bundle in nsArray{
                        if let nsDictionary = bundle as? NSDictionary{
                            if let time = nsDictionary["tatt_time"] as? String, let date = nsDictionary["tatt_date"] as? String{
                                self.timeTxt = time
                                self.dateTxt = date
                                print("time is \(time)")
                                print("date is \(date)")
                            }
                        }
                    }

                }

            case .failure(let e):   //통신 실패
                print(e.localizedDescription)
           
                
            }
            
            
            
            //통신후 컬렉션뷰 리로드
            self.collectionView.reloadData()
            self.timeArray = self.timeTxt.components(separatedBy: "시")
          
            
            //컬렉션셀에 넣어줄 데이터 준비
            self.list = {
               var datalist = [FindTattistVO]()
                for time in self.timeArray{
                    let fto = FindTattistVO()
                    fto.tatt_time = time
                    
                    datalist.append(fto)
                }
                return datalist
            }()
        }
    }
    
    
    
    
    
    
    //보여질 갯수 ..서버에서 받아와서 넣어줘야함
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("timeArray.count is \(self.timeArray.count)")
        return self.timeArray.count-1
      }
      
    //셀에 데이터 세팅
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingTimeCell", for: indexPath) as! BookingTimeCell
        
        //타티스트가 가능하다고 선택했던 시간 넣어주기
        cell.btnAvailableTime.setTitle(row.tatt_time!+"시", for: .normal)
        
        return cell
      }
    
    //셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row) 시간을 선택하였다")
    }
    
    
    
        //피커뷰 컬럼 수
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       

       //컴포넌트가 가질 목록의 길이
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            //부위 피커뷰일 경우
            if pickerView == pickBodyPart{
                return self.bodyPartList.count
            }else if pickerView == pickSize{
            //사이즈 피커뷰일 경우
            return self.sizeList.count
            }
        return 1
       }

       //피커뷰 각 행에 출력될 타이틀
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            //부위 피커뷰일 경우
            if pickerView == pickBodyPart{
                return self.bodyPartList[row]
            }else if pickerView == pickSize{
                //사이즈 피커뷰일 경우
                return self.sizeList[row]
            }
        return ""
            
       }

       //피커뷰 선택시 이벤트
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //부위 선택시
        if pickerView == pickBodyPart{
            selectedBodyPart = self.bodyPartList[row]
        }else if pickerView == pickSize{
            //사이즈 선택시
            selectedSize = self.sizeList[row]
        }
        
        
    }

//       //피커뷰 내부 폰트사이즈 등 조절
//       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//           var pickerLabel: UILabel? = (view as? UILabel)
//           if pickerLabel == nil {
//               pickerLabel = UILabel()
//               pickerLabel?.font = UIFont(name: "System Medium", size:12)
//               pickerLabel?.textAlignment = .center
//           }
////            pickerLabel?.text = self.bodyPartList[row]
//
//           return pickerLabel!
//       }
    
    
    
    
    
}
