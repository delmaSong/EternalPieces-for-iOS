//
//  LikeTabBarController.swift
//  EternalPieces
//
//  Created by delma on 26/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//


import UIKit
class LikeTabBarContoller: UITabBarController{
    
    let imgTop = UIImageView()      //상단 이미지
    let btnBack = UIButton(type: .system)   //뒤로가기 버튼
    let lblTitle = UILabel()        //좋아요 타이틀
    
    let tabView = UIView()      //탭바로 사용될 뷰
    let tabItem01 = UIButton(type: .system)     //탭바에 들어갈 버튼
    let tabItem02 = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true     //기존 탭바 숨김
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        //상단 이미지 설정
        self.imgTop.frame = CGRect(x: 0, y: 0, width: width, height: height/7 )
        self.imgTop.image = UIImage(named: "banner")
        //self.imgTop.contentMode = .scaleAspectFill
        self.imgTop.backgroundColor = UIColor.white
        self.imgTop.alpha = 0.88
        
        self.view.addSubview(imgTop)
        
        
        //뒤로가기 버튼 설정
        self.btnBack.frame = CGRect(x: 20, y: self.imgTop.frame.height / 2, width: 0, height: 0)
        self.btnBack.setTitle("back", for: .normal)
        self.btnBack.setTitleColor(UIColor.white, for: .normal)
        self.btnBack.sizeToFit()
        self.btnBack.addTarget(self, action: #selector(goToBack(_:)), for: .touchUpInside)
        self.view.addSubview(btnBack)
        
        
        //타이틀 레이블 설정
        self.lblTitle.frame = CGRect(x:(self.imgTop.frame.width / 2) - 40 , y:self.imgTop.frame.height / 2, width: 0, height: 0)
        self.lblTitle.text = "좋아요"
        self.lblTitle.textColor = UIColor.white
        self.lblTitle.font = UIFont.boldSystemFont(ofSize: 32)
        self.lblTitle.sizeToFit()
        
        self.view.addSubview(lblTitle)
        
        
        //탭바 설정
        self.tabView.frame = CGRect(x:0, y: self.imgTop.frame.height, width: width, height: 50)
        self.view.addSubview(tabView)
        
        //버튼 너비와 높이 설정
        let tabBtnWidth = self.tabView.frame.size.width / 2
        let tabBtnHeight = self.tabView.frame.height
        
        //버튼영역 설정
        self.tabItem01.frame = CGRect(x: 0, y:0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem02.frame = CGRect(x: tabBtnWidth, y:0, width: tabBtnWidth, height: tabBtnHeight)
        
        //버튼의 공통 속성을 설정하고 뷰에 추가한다
        self.addTabBarBtn(btn: tabItem01, title: "도안", tag: 0)
        self.addTabBarBtn(btn: tabItem02, title: "타티스트", tag: 1)
      
        
        //처음에 첫번째 탭이 선택되어 있도록 초기 상태 정의해둠
        self.onTabBarItemClick(self.tabItem01)
        
    }
    
    //버튼 공통 속성 정의 메소드
    func addTabBarBtn(btn: UIButton, title: String, tag: Int){
        
        btn.setTitle(title, for: .normal)
        btn.tag = tag
        
        btn.setTitleColor(UIColor.black, for: .normal)
        
        
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
       
        
        //인자값으로 입력된 버튼만 선택된 상태로 변경한다
        sender.isSelected = true
        sender.tintColor = colorli
        
        //버튼에 설정된 태그값을 사용해 뷰컨트롤러를 전환한다
        self.selectedIndex = sender.tag
    }
    
    
    @objc func goToBack(_ sender: UIButton){
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
}
