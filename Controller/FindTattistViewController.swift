//
//  FindTattistViewController.swift
//  EternalPieces
//
//  Created by delma on 17/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

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
        
        //서버에서 데이터 가져오기
        getData()
    }
    
    //서버에서 json list  받을 튜플
    var dataTuple : (tId: String, tInfo: String, tPhoto: String) = ("", "", "")
    //서버에서 json list 받을 어레이.
    var dataArray : [(String, String, String)] = []
    //어레이 인서트시 사용할 인덱스
    var num: Int = 0
    //컬렉션뷰에 넣어줄 데이터 리스트
    var list: [FindTattistVO] = []
    
    //피커뷰에 담길 데이터.. 서울일때와 경기도일때 smallArea 데이터 달라야하는데,,
    var bigAreaList = ["서울시", "경기도", "강원도", "충청도"]
    var smallAreaList = ["마포구", "용산구", "서대문구","중구"]
    

    

    
    
    //서버에서 타티스트 모든 목록 가져오기
      func getData(){
          let url = "http://127.0.0.1:1234/api/join_api/"
          let doNetwork = Alamofire.request(url)
          doNetwork.responseJSON{(response) in
              switch response.result{
              case .success(let obj):
                  if let nsArray = obj as? NSArray{       //어레이 벗기면 딕셔너리
                      for bundle in nsArray{
                          if let nsDictionary = bundle as? NSDictionary{
                              //dictionary 벗겨서 튜플에 각 데이터 삽입
                              if let tId = nsDictionary["tatt_id"] as? String, let tInfo = nsDictionary["tatt_intro"] as? String, let tPhoto = nsDictionary["tatt_profile"] as? String {
                                  self.dataTuple = (tId, tInfo, tPhoto)   //튜플에 데이터삽입
                              }
                          }
                          
                          //어레이에 튜플로 이뤄진 값 삽입
                          self.dataArray.insert(self.dataTuple, at: self.num)
                          self.num += 1
                      }
                      //컬렉션뷰 데이터 리로드
                      self.collectionView.reloadData()
                  }
              case .failure(let e):   //통신 실패
                  print(e.localizedDescription)
              }
            
            //컬렉션셀에 넣어줄 데이터 준비
            self.list = {
               var datalist = [FindTattistVO]()
                
                for(tId, tInfo, tPhoto) in self.dataArray{
                    let fvo = FindTattistVO()
                    fvo.profile = tPhoto
                    fvo.tattistId = tId
                    fvo.tattistIntro = tInfo
                    
                    datalist.append(fvo)
                }
                return datalist
            }()
          }
      }
    
    

    
    
    //셀 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    //셀 내용 삽입
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindTattistCell", for: indexPath) as! FindTattistCell
        
        let imgURL = URL(string: row.profile!)
        cell.profile.kf.setImage(with: imgURL)
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
