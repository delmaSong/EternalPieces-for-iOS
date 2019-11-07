//
//  TattistWithTabBarController.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class TattistWithTabBarController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let tabView = UIView()                              //탭바로 사용될 뷰
    let tabItem01 = UIButton(type: .system)             //탭바에 들어갈 버튼 세개
    let tabItem02 = UIButton(type: .system)
    let tabItem03 = UIButton(type: .system)
    
    let imgTop = UIImageView()                          //상단 배경이미지
    let imgProfile = UIImageView()                      //타티스트 프로필 이미지
    
    let btnBack = UIButton(type: .system)               //뒤로가기 버튼
    let btnChat = UIButton(type: .system)               //상담하기 버튼
    let btnLike = UIButton(type: .system)               //좋아요 버튼
    
    let lblId = UILabel()                               //타티스트 아이디
    let lblIntro = UITextView()                         //타티스트 셀프 소개
    
    let editBtn = UIButton()                            //마이페이지 수정버튼
    let editDoneBtn = UIButton()                        //마이페이지 수정완료버튼
    
    let editProfileBtn = UIButton()                     //프로필사진 수정버튼
    let editBackBtn = UIButton()                        //배경사진 수정버튼
    
    //건네받을 타티스트 아이디
    var tattId: String = ""
    //이미지 수정시 플래그
    var setImgFlag: Int = 0
    //서버로 넘어갈 이미지 압축파일 변수
    var profileImgData: Data!
    var backImgData: Data!
    //타티스트 고유아이디
    var uniqueId: Int = 0
    //좋아하는 타티스트 담을 어레이
    var likeArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true     //기존 탭바 숨겨줌
        
        //서버에서 데이터 가져오기
         getData()
         getLikeData()
        
        
        let width = self.view.frame.width
        let height : CGFloat = 50
        
        //배경 이미지 설정
        self.imgTop.frame = CGRect(x: 0, y: 0, width: width, height: self.view.frame.height / 4)
        self.imgTop.image = UIImage(named: "tattooGun")
        //self.imgTop.contentMode = .scaleAspectFill
        self.imgTop.backgroundColor = UIColor.white
        self.imgTop.alpha = 0.88
        
        self.view.addSubview(imgTop)
        
        
        
        self.tabView.frame = CGRect(x: 0, y:self.imgTop.frame.height + 50, width: width, height: height)
        //self.tabView.backgroundColor = UIColor.brown
        
        self.view.addSubview(tabView)       //뷰에 탭바 추가
        
        //버튼의 너비와 높이 설정
        let tabBtnWidth = self.tabView.frame.size.width / 3
        let tabBtnHeight = self.tabView.frame.height
        
        //버튼 영역 설정
        self.tabItem01.frame = CGRect(x: 0, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem02.frame = CGRect(x: tabBtnWidth, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem03.frame = CGRect(x: tabBtnWidth * 2, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        
        //버튼의 공통 속성을 설정하고 뷰에 추가한다
        self.addTabBarBtn(btn: tabItem01, title: "도안", tag: 0)
        self.addTabBarBtn(btn: tabItem02, title: "작업물", tag: 1)
        self.addTabBarBtn(btn: tabItem03, title: "후기", tag: 2)
        
        //처음에 첫번째 탭이 선택되어 있도록 초기 상태 정의해둠
        self.onTabBarItemClick(self.tabItem01)
        
        
        
        //프로필 이미지 설정
        self.imgProfile.frame = CGRect(x: 20, y: self.imgTop.frame.height * (3/4), width: width * 18/83, height: width * 18/83)
        self.imgProfile.image = UIImage(named: "codog.jpeg")
        self.imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        self.imgProfile.layer.masksToBounds = true
        
        self.view.addSubview(imgProfile)
        
        
        //뒤로가기 버튼 설정
        self.btnBack.frame = CGRect(x: 20, y: 30, width: 0, height: 0)
        self.btnBack.setTitle("back", for: .normal)
        self.btnBack.setTitleColor(UIColor.white, for: .normal)
        self.btnBack.sizeToFit()
        self.btnBack.addTarget(self, action: #selector(goToBack(_:)), for: .touchUpInside)
        self.view.addSubview(btnBack)
        
        
        //타티스트 아이디 레이블 설정
        self.lblId.frame = CGRect(x: 25 + (width * 18/83), y: self.imgTop.frame.height * 9 / 10, width: 0, height: 0)
        self.lblId.text = "tattistId"
        self.lblId.textColor = UIColor.white
        self.lblId.sizeToFit()
        
        
        self.view.addSubview(lblId)
        
        
        //타티스트 셀프소개 레이블 설정
        self.lblIntro.frame = CGRect(x: 25 + (width * 18/83), y: (self.imgTop.frame.height * 9 / 10) + self.lblId.frame.height+5, width: width * 3 / 5, height: self.imgTop.frame.height / 4)
        self.lblIntro.text = "타티스트 셀프 소개 들어갈 곳"
        self.lblIntro.textColor = UIColor.black
        self.lblIntro.isEditable = false
        
        self.view.addSubview(lblIntro)
        
        //좋아요 버튼 설정
        self.btnLike.frame = CGRect(x:(self.imgTop.frame.width * 7 / 8 ) + 10 ,y:(self.imgTop.frame.height * 9 / 10) - 45 ,width:25 , height:25)
        self.btnLike.setImage(UIImage(named: "emptyHeart.png"), for: .normal)
        self.btnLike.tintColor = UIColor.red
        self.btnLike.addTarget(self, action: #selector(doLike(_:)), for: .touchUpInside)
        self.view.addSubview(btnLike)
   
        //상담하기 버튼 설정
        self.btnChat.frame = CGRect(x: (self.imgTop.frame.width * 7 / 8 ) - 5, y: (self.imgTop.frame.height * 9 / 10) - 10, width: 0, height: 0)
        self.btnChat.setTitle("상담하기", for: .normal)
        self.btnChat.backgroundColor = UIColor.white
        self.btnChat.setTitleColor(UIColor.black, for: .normal)
        self.btnChat.layer.borderColor = UIColor.white.cgColor
        self.btnChat.layer.borderWidth = 1
        
        self.btnChat.layer.cornerRadius = 8
        self.btnChat.sizeToFit()
        
        self.view.addSubview(btnChat)
        
        
        
        //수정버튼 이미지
        let editIcon: UIImage = UIImage(named:"edit_icon")!
        //수정버튼 버튼 설정
        self.editBtn.frame = CGRect(x:( width * 7/8), y: 30, width: 25, height:25)
        self.editBtn.setImage(editIcon, for: .normal)
        self.editBtn.addTarget(self, action: #selector(goEdit(_:)), for: .touchUpInside)

        self.view.addSubview(editBtn)
        
     
    
    }
    
    
    
    
    
    
    //버튼 공통 속성 정의 메소드
    func addTabBarBtn(btn: UIButton, title: String, tag: Int){
        
        btn.setTitle(title, for: .normal)
        btn.tag = tag
        
        btn.setTitleColor(UIColor.black, for: .normal)
        
        //btn.setTitleColor(UIColor.gray, for: .selected)
        
        
        //버튼에 액션 메소드를 연결
        btn.addTarget(self, action: #selector(onTabBarItemClick(_:)), for: .touchUpInside)
        
        //csView에 버튼을 추가
        self.tabView.addSubview(btn)
    }
    
   
    
    let colorli = #colorLiteral(red: 0.9730329949, green: 0.6387086235, blue: 0.5980552073, alpha: 1)
    //버튼 선택시 이벤트
    @objc func onTabBarItemClick(_ sender: UIButton){
        
        //모든 버튼을 선택되지 않은 상태로 초기화 한다
        self.tabItem01.isSelected = false
        self.tabItem02.isSelected = false
        self.tabItem03.isSelected = false
        
        //인자값으로 입력된 버튼만 선택된 상태로 변경한다
        sender.isSelected = true
        sender.tintColor = colorli
        
        //버튼에 설정된 태그값을 사용해 뷰컨트롤러를 전환한다
        self.selectedIndex = sender.tag
        
        
        //noti로 데이터 전달
        if self.selectedIndex == 1{
            NotificationCenter.default.post(name: .getWorkData, object: self.tattId)
        }else if self.selectedIndex == 2 {
            NotificationCenter.default.post(name: .getReviewData, object: self.tattId)
        }else {
            NotificationCenter.default.post(name: .getData, object: self.tattId)
        }

        
        
    }
    
    
    

    
    @objc func goToBack(_ sender: UIButton){
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    //MARK: - 서버와 호출
    //서버에서 데이터 가져오기
    func getData(){
        let url = "http:127.0.0.1:1234/api/join_api/?tatt_id="
        let doNetwork = Alamofire.request(url+self.tattId)
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                if let nsArray = obj as? NSArray{       //어레이 벗기면 딕셔너리
                     for bundle in nsArray{
                         if let nsDictionary = bundle as? NSDictionary{
                             if let tId = nsDictionary["tatt_id"] as? String, let tInfo = nsDictionary["tatt_intro"] as? String, let tPhoto = nsDictionary["tatt_profile"] as? String, let uniqueId = nsDictionary["id"] as? Int{
                                self.lblId.text = tId
                                self.lblIntro.text = tInfo
                                self.imgProfile.kf.setImage(with: URL(string: tPhoto))
                                self.uniqueId = uniqueId
                               
                             }
                            
                            if let bPhoto = nsDictionary["back_img"] as? String{
                                self.imgTop.kf.setImage(with: URL(string: bPhoto))
                            }
//                            if self.likeArray.contains(String(self.uniqueId)){
//                               self.btnLike.setImage(UIImage(named: "filledHeart.png"), for: .normal)
//                           }
                            
                         }
                         
                     }
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    //기존 좋아요 정보 가져오기
    func getLikeData(){
        let url = "http:127.0.0.1:1234/api/likes/?user="
              let user = "1111"       //현재 로그인한 유저 아이디
              let doNetwork = Alamofire.request(url+user)
              doNetwork.responseJSON { (response) in
                  switch response.result{
                  case .success(let obj):
                      if let nsArray = obj as? NSArray{       //array 벗김
                                  for bundle in nsArray {
                                      if let nsDictionary = bundle as? NSDictionary{         //dictionary 벗겨서 튜플에 각 데이터 삽입
                                          if let like_tattist = nsDictionary["like_tattist"] as? String{
                                              self.likeArray.append(like_tattist)
                                          }
                                      }
                                  }
                                if self.likeArray.contains(String(self.uniqueId)){
                                   self.btnLike.setImage(UIImage(named: "filledHeart.png"), for: .normal)
                               }
                              }
                  case .failure(let e):
                      print(e.localizedDescription)
                  }
              }
    }
    
    //좋아요 버튼 선택시
    @objc func doLike(_ sender: UIButton){
        var url = "http:127.0.0.1:1234/api/likes/"
        
        if !self.likeArray.contains(String(uniqueId)){   //안좋아했던 타티스트면
            sender.setImage(UIImage(named:"filledHeart.png"), for: .normal)
            let params = [ "user" : "1111", "like_tattist": String(uniqueId) ] as [String : Any]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            self.likeArray.append(String(uniqueId))
        }else{  //좋아했던 타티스트면
            sender.setImage(UIImage(named:"emptyHeart.png"), for: .normal)
            url = url + "?user=" + String("1111") + "&like_tattist=" + String(uniqueId)
            Alamofire.request(url, method: .get)
            if let index = self.likeArray.firstIndex(of: String(uniqueId)){
                          self.likeArray.remove(at: index)
                      }
        }//else
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //옵저버 제거
        NotificationCenter.default.removeObserver(self, name: .getData, object: nil)
        NotificationCenter.default.removeObserver(self, name: .getReviewData, object: nil)
        NotificationCenter.default.removeObserver(self, name: .getWorkData, object: nil)
        print("옵저버 제거되었다~~~~~")
    }
    
    //MARK: - 마이페이지 수정기능 관련
    @objc func goEdit(_ sender: UIButton){
//        if let st = self.storyboard?.instantiateViewController(withIdentifier: "SetTattistTime") as? SetTattistTimeController{
//            st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//            self.present(st, animated: true)
//        }
        let editIcon: UIImage = UIImage(named:"edit_icon")!
        let alert = UIAlertController(title:"알림", message: "마이페이지를 수정하겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default){ (action) in
            //기존 수정 버튼 숨김
            self.editBtn.isHidden = true
            //기존 타티스트 소개란 편집 가능
            self.lblIntro.isEditable = true
            self.lblIntro.layer.borderColor = UIColor.gray.cgColor
            self.lblIntro.layer.borderWidth = 1
            self.lblIntro.layer.cornerRadius = 5
            //수정 완료 버튼 생성
            self.editDoneBtn.frame = CGRect(x:( self.view.frame.width * 7/8), y: 30, width: 50, height:50)
            self.editDoneBtn.setTitle("완료", for: .normal)
            self.editDoneBtn.addTarget(self, action: #selector(self.editProfile(_:)), for: .touchUpInside)
            self.view.addSubview(self.editDoneBtn)
            //배경사진 수정 버튼 생성
            self.editBackBtn.frame = CGRect(x: self.view.frame.width/2 , y: self.imgTop.frame.height/2 , width: 25, height: 25)
            self.editBackBtn.setImage(editIcon, for: .normal)
            self.editBackBtn.addTarget(self, action: #selector(self.setImg(_:)), for: .touchUpInside)
            self.view.addSubview(self.editBackBtn)
            //프로필사진 수정 버튼 생성
            self.editProfileBtn.frame = CGRect(x: 50, y: self.imgTop.frame.height, width: 25, height: 25)
            self.editProfileBtn.setImage(editIcon, for: .normal)
            self.editProfileBtn.tintColor = UIColor.black
            self.editProfileBtn.backgroundColor = self.colorli
            self.editProfileBtn.addTarget(self, action: #selector(self.setImg(_:)), for: .touchUpInside)
            self.view.addSubview(self.editProfileBtn)
            
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func editProfile(_ sender:UIButton){
        //서버 호출해 마이페이지 수정 기능 구현하기
        let params = [
            "tatt_intro" : self.lblIntro.text!
        ]
        let url = "http:127.0.0.1:1234/api/join_api/"+String(self.uniqueId)+"/"
        let headers = ["Content-Type" : "multipart/form-data"]
        Alamofire.upload(multipartFormData: {multipartFormData in
            for(key, value) in params{
                multipartFormData.append(value.data(using:.utf8)!, withName: key) }
            if self.profileImgData != nil {
                multipartFormData.append(self.profileImgData!, withName: "tatt_profile", fileName: "profile.jpg", mimeType: "jpg/png")
            }
            if self.backImgData != nil {
                multipartFormData.append(self.backImgData!, withName: "back_img", fileName: "back.jpg", mimeType: "jpg/png")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .put, headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON{ response in
                    debugPrint(response.result.value!)  }
            case .failure(let error):
                print(error)
            }//end switch
        }
        self.viewDidLoad()
    }
    
    @objc func setImg(_ sender:UIButton){
        //이미지선택
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: false)
        
        if sender == self.editProfileBtn {
            self.setImgFlag = 1
        }else if sender == self.editBackBtn{
            self.setImgFlag = 2
        }
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
            
            if self.setImgFlag == 1 {        //프로필 사진 세팅
                self.imgProfile.image = img
                self.profileImgData = img?.jpegData(compressionQuality: 0.7)
            }else if self.setImgFlag == 2{   //배경사진 세팅
                self.imgTop.image = img
                self.backImgData = img?.jpegData(compressionQuality: 0.7)
            }
        }
    }
    
    
}

//옵저버에 이름 추가
extension Notification.Name{
    static let getData = Notification.Name("getData")
    static let getReviewData = Notification.Name("getReviewData")
    static let getWorkData = Notification.Name("getWorkData")
}
