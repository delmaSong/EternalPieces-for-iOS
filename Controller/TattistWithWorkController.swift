//
//  TattistWithWorkController.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class TattistWithWorkController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
   
    @IBOutlet var collectionView: UICollectionView!
    
    //서버에서 json list  받을 튜플
    var dataTuple : (dId: Int, dPhoto: String) = (0, "")
    //서버에서 json list 받을 어레이.
    var dataArray : [(Int, String)] = []
    //어레이 인서트시 사용할 인덱스
    var num: Int = 0
    //컬렉션뷰에 넣어줄 데이터 리스트
    var list: [WorksVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .getData, object: nil)
    }
    
    
     @objc func getData(_ notification: Notification){
          let tattId = notification.object as! String
          let url = "http:127.0.0.1:1234/api/works/?tatt_id="
          let doNetwork = Alamofire.request(url+tattId)
          doNetwork.responseJSON{(response) in
              switch response.result{
              case .success(let obj):
                  if let nsArray = obj as? NSArray{       //어레이 벗기면 딕셔너리
                      for bundle in nsArray{
                          if let nsDictionary = bundle as? NSDictionary{
                              //dictionary 벗겨서 튜플에 각 데이터 삽입
                              if let dId = nsDictionary["id"] as? Int, let dPhoto = nsDictionary["works"] as? String{
                                  self.dataTuple = (dId, dPhoto)   //튜플에 데이터삽입
                              }
                          }
                          
                          //어레이에 튜플로 이뤄진 값 삽입
                          self.dataArray.insert(self.dataTuple, at: self.num)
                          self.num += 1
                      }
                      //컬렉션뷰 데이터 리로드
                      self.collectionView.reloadData()
                  }
              case .failure(let e):
                  print(e.localizedDescription)
              }
              
              //컬렉션셀에 넣어줄 데이터 준비
              self.list = {
                 var datalist = [WorksVO]()
                  
                  for(dId, dPhoto) in self.dataArray{
                      var fvo = WorksVO()
                      fvo.works = dPhoto
                      fvo.id = dId
                      
                      datalist.append(fvo)
                  }
                  return datalist
              }()
          }
      }
    
  
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TattistWithWorkCell", for: indexPath) as! TattistWithWorkCell
        
        cell.work.kf.setImage(with: URL(string:row.works!))
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
    }
    
}

//컬럼 갯수 세개씩 나오도록 사이즈 조정
extension TattistWithWorkController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 20
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/3, height: collectionCellSize/3)
        
    }
    
}
