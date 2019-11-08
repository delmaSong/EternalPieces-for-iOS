//
//  LikeDesignController.swift
//  EternalPieces
//
//  Created by delma on 26/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class LikeDesignController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var collectionView: UICollectionView!
    
    //좋아하는 타티스트 담을 어레이
    var likeArray: [String] = []
    
    //서버에서 json list  받을 튜플
    var dataTuple : (tId: String, tInfo: String, tPhoto: String, qId: Int) = ("", "", "", 0)
    //서버에서 json list 받을 어레이.
    var dataArray : [(String, String, String, Int)] = []
    //컬렉션뷰에 넣어줄 데이터 리스트
    var list: [FindStyleVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame = CGRect(x:0, y:self.view.frame.height / 7 + 50, width: self.view.frame.width , height: self.view.frame.height)
        
       
        getLikeData()
        getData()
    }
    
    //로그인된 유저 아이디로 좋아요 데이터 가져오기
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
                                    if let like_design = nsDictionary["like_design"] as? String{
                                        self.likeArray.append(like_design)
                                    }
                                }
                            }
                        }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    
    func getData(){
        let url = "http:127.0.0.1:1234/api/upload-design/"
        let doNetwork = Alamofire.request(url)
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                if let nsArray = obj as? NSArray{       //array 벗김
                    for bundle in nsArray {
                        if let nsDictionary = bundle as? NSDictionary{         //dictionary 벗겨서 튜플에 각 데이터 삽입
                            if let tId = nsDictionary["tatt_id"] as? String, let dDesc = nsDictionary["design_desc"] as? String
                                , let dPhoto = nsDictionary["design_photo"] as? String, let dId = nsDictionary["id"] as? Int{
                                self.dataTuple = (tId, dDesc, dPhoto, dId)   //튜플에 데이터 삽입
                            }
                        }
                    
                        //어레이에 튜플로 이뤄진 값 삽입
                        self.dataArray.append(self.dataTuple)
                    }
                }
            case .failure(let e): //통신 실패
                print(e.localizedDescription)
            }
          
            //컬렉션셀에 넣어줄 데이터 준비
            self.list = {
                  var datalist = [FindStyleVO]()

                  for(tId, dDesc, dPhoto, dId) in self.dataArray{
                    //내가 좋아한 도안만 컬렉션셀에 담음
                    if self.likeArray.contains(String(dId)){
                      var fvo = FindStyleVO()
                      fvo.tatt_id = tId
                      fvo.design_desc = dDesc
                      fvo.design_photo = dPhoto
                      fvo.design_id = dId
                                           
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeDesignCell", for: indexPath) as! LikeDesignCell
        
        let imgURL = URL(string: row.design_photo!)
        cell.design.kf.setImage(with: imgURL)
        cell.tattistId?.text = row.tatt_id
        cell.decsription?.text = row.design_desc
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(doLike(_:)), for: .touchUpInside)
        
        //좋아요 배열에 포함되어있다면 버튼 색상 변경
        if !self.likeArray.contains(String(row.design_id!)){
            cell.likeBtn.setImage(UIImage(named:"emptyHeart.png"), for: .normal)
        }
        
        return cell
    }
    
    //셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "DesignDetailView"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        }
    }
    
    
    //좋아요 버튼 선택시
       @objc func doLike(_ sender: UIButton){
           let data = self.list[sender.tag]
           var url = "http:127.0.0.1:1234/api/likes/"

           if !self.likeArray.contains(String(data.design_id!)) {  //좋아요 안눌렀던거면
               sender.setImage(UIImage(named:"filledHeart.png"), for: .normal)
               //서버에 데이터 보내기
               let params = [ "user" : "1111", "like_design": String(data.design_id!) ] as [String : Any]
               Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
               self.likeArray.append(String(data.design_id!))

           }else{//좋아요 눌렀었던 거면
               //유저 아이디값 로그인한 사용자로 변경하기
               sender.setImage(UIImage(named:"emptyHeart.png"), for: .normal)
               url = url + "?user=" + String("1111") + "&like_design=" + String(data.design_id!)
               Alamofire.request(url, method: .get)
               if let index = self.likeArray.firstIndex(of: String(data.design_id!)){
                   self.likeArray.remove(at: index)
                   self.collectionView.reloadData()
               }
           }



       }
    
    
}
