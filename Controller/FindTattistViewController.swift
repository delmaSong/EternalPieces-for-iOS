//
//  FindTattistViewController.swift
//  EternalPieces
//
//  Created by delma on 17/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit

class FindTattistViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{

    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pickerBig: UIPickerView!
    @IBOutlet var pickerSmall: UIPickerView!
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pickerBig.dataSource = self
        pickerBig.delegate = self
        
        pickerSmall.dataSource = self
        pickerSmall.delegate = self
        
    }
    
    //컬렉션 셀에 담길 데이터
    var dataSet = [
        ("codog.jpeg","tattistId","tattist self introduce"),
        ("codog.jpeg","타티스트아이디","셀프 간단 소개쓰"),
        ("codog.jpeg","멍냥쓰","tattist self introduce"),
        ("codog.jpeg","멍뭉쓰","tattist self introduce"),
        ("codog.jpeg","더미데이터","tattist self introduce")
        
    ]
    
    //피커뷰에 담길 데이터.. 서울일때와 경기도일때 smallArea 데이터 달라야하는데,,
    var bigAreaList = ["서울시", "경기도", "강원도", "충청도"]
    var smallAreaList = ["마포구", "용산구", "서대문구","중구"]
    
    lazy var list: [FindTattistVO] = {
        
        var datalist = [FindTattistVO]()
        
        for(profile, tattistId, tattistIntro) in self.dataSet{
            let fvo = FindTattistVO()
            fvo.profile = profile
            fvo.tattistId = tattistId
            fvo.tattistIntro = tattistIntro
            
            datalist.append(fvo)
        }
        return datalist
    }()
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = self.list[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindTattistCell", for: indexPath) as! FindTattistCell
        
        cell.profile.image = UIImage(named: row.profile!)
        cell.tattistId?.text = row.tattistId
        cell.tattistIntro?.text = row.tattistIntro
        
        return cell
    }
    
    //셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
        
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "TattistWithTabBar"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        
        }
    }
    
    
    
    //피커뷰 컬럼 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.bigAreaList.count
    }
    
    //컴포넌트가 가질 목록의 길이
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    //피커뷰 각 행에 출력될 타이틀
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.bigAreaList[row]
    }
    
    //피커뷰 선택시 이벤트
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         NSLog("피커뷰로 \(self.bigAreaList[row])를 선택하였습니다")
    }
        
        
    
    
    
    
    
}
