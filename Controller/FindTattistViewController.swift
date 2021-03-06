
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
    
    //지역 대분류 리스트
    let bigArea = ["지역","서울", "부산", "제주"]
    let seoul = ["전체","마포구", "서대문구", "종로구"]
    let busan = ["전체","수영구", "동래구", "중구"]
    let jeju = ["전체","서귀포시", "제주시", "중구"]
    //대분류 선택 플래그
    var big: String = ""
    //선택된 항목
    var selectedBig: String = ""
    var selectedSmall: String = ""
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pickerBig.delegate = self
        pickerBig.dataSource = self
        
        pickerSmall.delegate = self
        pickerSmall.dataSource = self
        
        //서버에서 데이터 가져오기
        getData(url:"http://127.0.0.1:1234/api/join_api/", filter: "")
        getLikeData()   //좋아요데이터 가져오기
    }
    
    //서버에서 json list  받을 튜플
    var dataTuple : (tId: String, tInfo: String, tPhoto: String, qId: Int) = ("", "", "", 0)
    //서버에서 json list 받을 어레이.
    var dataArray : [(String, String, String, Int)] = []
    //어레이 인서트시 사용할 인덱스
    var num: Int = 0
    //컬렉션뷰에 넣어줄 데이터 리스트
    var list: [FindTattistVO] = []


    //좋아하는 타티스트 담을 어레이
    var likeArray: [String] = []
    

//MARK: - 서버에서 데이터 호출
    //좋아요 데이터 가져오기
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
                        }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    
    //서버에서 타티스트 모든 목록 가져오기
    func getData(url: String, filter: String){
        let encodingString = (url+filter).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
          let doNetwork = Alamofire.request(encodingString)
          doNetwork.responseJSON{(response) in
              switch response.result{
              case .success(let obj):
                  if let nsArray = obj as? NSArray{       //어레이 벗기면 딕셔너리
                      for bundle in nsArray{
                          if let nsDictionary = bundle as? NSDictionary{
                              //dictionary 벗겨서 튜플에 각 데이터 삽입
                              if let tId = nsDictionary["tatt_id"] as? String, let tInfo = nsDictionary["tatt_intro"] as? String, let tPhoto = nsDictionary["tatt_profile"] as? String, let qId = nsDictionary["id"] as? Int  {
                                  self.dataTuple = (tId, tInfo, tPhoto, qId)   //튜플에 데이터삽입
                              }
                          }
                          
                          //어레이에 튜플로 이뤄진 값 삽입
                          self.dataArray.insert(self.dataTuple, at: self.num)
                          self.num += 1
                      }
                  }
              case .failure(let e):   //통신 실패
                  print(e.localizedDescription)
              }
            
            //컬렉션셀에 넣어줄 데이터 준비
            self.list = {
               var datalist = [FindTattistVO]()
                
                for(tId, tInfo, tPhoto, qId) in self.dataArray{
                    let fvo = FindTattistVO()
                    fvo.profile = tPhoto
                    fvo.tattistId = tId
                    fvo.tattistIntro = tInfo
                    fvo.id = String(qId)
                    
                    datalist.append(fvo)
                }
                return datalist
            }()
            //컬렉션뷰 데이터 리로드
            self.collectionView.reloadData()
          }
        self.num=0
      }
    
    

    
    //MARK: - 컬렉션뷰 셀 설정
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
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(doLike(_:)), for: .touchUpInside)
        
        //좋아요 배열에 포함되어있다면 버튼 색상 변경
        if self.likeArray.contains(row.id!){
            cell.likeBtn.setImage(UIImage(named:"filledHeart.png"), for: .normal)
        }
        return cell
    }
    
    //셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = self.list[indexPath.row]
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "TattistWithTabBar") as? TattistWithTabBarController{
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            lmc.tattId = row.tattistId!
            self.present(lmc, animated: true)
        
        }
    }
    
    
    //좋아요 버튼 선택시
    @objc func doLike(_ sender: UIButton){
        let data = self.list[sender.tag]
        var url = "http:127.0.0.1:1234/api/likes/"
        
        if !self.likeArray.contains(data.id!){   //안좋아했던 타티스트면
            sender.setImage(UIImage(named:"filledHeart.png"), for: .normal)
            let params = [ "user" : "1111", "like_tattist": data.id! ] as [String : Any]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            self.likeArray.append(data.id!)
        }else{  //좋아했던 타티스트면
            sender.setImage(UIImage(named:"emptyHeart.png"), for: .normal)
            url = url + "?user=" + String("1111") + "&like_tattist=" + data.id!
            Alamofire.request(url, method: .get)
            if let index = self.likeArray.firstIndex(of: data.id!){
                          self.likeArray.remove(at: index)
                          self.collectionView.reloadData()
                      }
        }//else
    }//doLike
    
    
    //MARK: - 피커뷰 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //컴포넌트가 가질 목록의 길이
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           //대분류 피커뷰일경우
             if pickerView == pickerBig{
                 return self.bigArea.count
             }else if pickerView == pickerSmall{
                 return self.seoul.count
             }
             return 1
    }
    
    //피커뷰 각 행에 출력될 타이틀
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerBig {
           return self.bigArea[row]
       }else if pickerView == pickerSmall && big == "서울"{
           return self.seoul[row]
       }else if pickerView == pickerSmall && big == "부산"{
           return self.busan[row]
       }else if pickerView == pickerSmall && big == "제주"{
           return self.jeju[row]
       }else if pickerView == pickerSmall{
           return self.seoul[row]
       }
        return ""
        
    }
    
    //피커뷰 선택시 이벤트
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView == pickerBig && pickerBig.selectedRow(inComponent: 0) == 1 {
           pickerSmall.selectRow(0, inComponent: 0, animated: true)
           self.selectedBig = "서울"
           self.big = "서울"          //두번째 피커뷰 세팅 플래그
           self.pickerSmall.reloadAllComponents()   //두번째 피커뷰의 항목들 리로드
            
            //기존 어레이 삭제
            self.dataArray.removeAll()
        
            getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedBig)
       }else if pickerView == pickerBig && pickerBig.selectedRow(inComponent: 0) == 2{
           pickerSmall.selectRow(0, inComponent: 0, animated: true)
           self.selectedBig = "부산"
           self.big = "부산"
           self.pickerSmall.reloadAllComponents()
           
            self.dataArray.removeAll()
            getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedBig)

            
        }else if pickerView == pickerBig && pickerBig.selectedRow(inComponent: 0) == 3{
           pickerSmall.selectRow(0, inComponent: 0, animated: true)
           self.selectedBig = "제주"
           self.big = "제주"
           self.pickerSmall.reloadAllComponents()

            self.dataArray.removeAll()
            getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedBig)

        }else if pickerView == pickerSmall && pickerBig.selectedRow(inComponent: 0) == 1{
           self.selectedSmall = self.seoul[row]
          
            self.dataArray.removeAll()
            
            if pickerSmall.selectedRow(inComponent: 0) == 0 {   //전체
                getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedBig)
            }else{
                getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedSmall)
            }
            

       }else if pickerView == pickerSmall && pickerBig.selectedRow(inComponent: 0) == 2{
           self.selectedSmall = self.busan[row]

            self.dataArray.removeAll()
            if pickerSmall.selectedRow(inComponent: 0) == 0 {   //전체
               getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedBig)
           }else{
               getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedSmall)
           }
       }else if pickerView == pickerSmall && pickerBig.selectedRow(inComponent: 0) == 3{
           self.selectedSmall = self.jeju[row]

            self.dataArray.removeAll()
            if pickerSmall.selectedRow(inComponent: 0) == 0 {   //전체
               getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedBig)
           }else{
               getData(url: "http://127.0.0.1:1234/api/join_api/?area=", filter: self.selectedSmall)
           }
       }
 

    
    }
        
        
    
    
  
    
    
}
