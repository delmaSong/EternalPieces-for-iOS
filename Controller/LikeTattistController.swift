//
//  LikeTattistController.swift
//  EternalPieces
//
//  Created by delma on 26/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class LikeTattistController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet var collectionView: UICollectionView!
    //서버에서 json list  받을 튜플
     var dataTuple : (tId: String, tInfo: String, tPhoto: String, qId: Int) = ("", "", "", 0)
     //서버에서 json list 받을 어레이.
     var dataArray : [(String, String, String, Int)] = []
     //컬렉션뷰에 넣어줄 데이터 리스트
     var list: [FindTattistVO] = []


     //좋아하는 타티스트 담을 어레이
     var likeArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame = CGRect(x:0, y:self.view.frame.height / 7 + 50, width: self.view.frame.width , height: self.view.frame.height)
        
        getLikeData()
        getData()
    }
    
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
       func getData(){
             let url = "http:127.0.0.1:1234/api/join_api/"
             let doNetwork = Alamofire.request(url)
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
                            self.dataArray.append(self.dataTuple)
                         }
                     }
                 case .failure(let e):   //통신 실패
                     print(e.localizedDescription)
                 }

               //컬렉션셀에 넣어줄 데이터 준비
               self.list = {
                  var datalist = [FindTattistVO]()
                   
                   for(tId, tInfo, tPhoto, qId) in self.dataArray{
                    //내가 좋아한 타티스트 데이터만 리스트에 넣음
                    if self.likeArray.contains(String(qId)){
                       let fvo = FindTattistVO()
                       fvo.profile = tPhoto
                       fvo.tattistId = tId
                       fvo.tattistIntro = tInfo
                       fvo.id = String(qId)
                       
                       datalist.append(fvo)
                    }
                   }
                   return datalist
               }()
               //컬렉션뷰 데이터 리로드
               self.collectionView.reloadData()
             }
         }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = self.list[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeTattistCell", for: indexPath) as! LikeTattistCell
        
        let imgURL = URL(string: row.profile!)
        cell.profile.kf.setImage(with: imgURL)
        cell.tattistId?.text = row.tattistId
        cell.tattistIntro?.text = row.tattistIntro
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(doLike(_:)), for: .touchUpInside)
        
        //좋아요 배열에 포함되어있다면 버튼 색상 변경
          if !self.likeArray.contains(row.id!){
              cell.likeBtn.setImage(UIImage(named:"emptyHeart.png"), for: .normal)
        }
        
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
    
    
    
    
    
    
}
