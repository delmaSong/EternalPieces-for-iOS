//
//  FindStyleViewController.swift
//  EternalPieces
//
//  Created by delma on 09/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class FindStyleViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    var selectedKey = ""    //버튼 선택시 서버 넘길 키워드
    
    //서버에서 json list 받을 튜플
      var dataTuple : (tId: String, tDesc: String, dPhoto: String, dId: Int) = ("", "", "", 0)
      //서버에서 json list 받을 어레이. 어레이 속에 튜플 들어간 구조
      var dataArray :[(String, String, String, Int)] = []
      //어레이 인서트시 사용할 인덱스
      var num:Int = 0
    var list: [FindStyleVO] = []
    
    
    override func viewDidLoad() {
        getData()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //레터링 버튼 클릭시
    @IBAction func btnLettering(_ sender: Any) {
        self.dataArray.removeAll()
        self.num = 0
        
        selectedKey = "lettering"
        getData(selectedKey: selectedKey)
    }
    
    //수채화 버튼 클릭시
    @IBAction func btnWaterColor(_ sender: Any) {
        self.dataArray.removeAll()
        self.num = 0
        
        selectedKey = "watercolor"
        getData(selectedKey: selectedKey)
    }
    
    //올드스쿨 버튼 클릭시
    @IBAction func btnOldSchool(_ sender: Any) {
        self.dataArray.removeAll()
        self.num = 0
        
        selectedKey = "oldschool"
        getData(selectedKey: selectedKey)
    }
    
    //이레즈미 버튼 클릭시
    @IBAction func btnIrezumi(_ sender: Any) {
        self.dataArray.removeAll()
        self.num = 0
        
        selectedKey = "irezumi"
        getData(selectedKey: selectedKey)
    }
    
    //블랙앤그레이 버튼 클릭시
    @IBAction func btnBnG(_ sender: Any) {
        self.dataArray.removeAll()
        self.num = 0
        
        selectedKey = "blackngray"
        getData(selectedKey: selectedKey)
    }
    
    //커버업 버튼 클릭시
    @IBAction func btnCoverUp(_ sender: Any) {
        self.dataArray.removeAll()
        self.num = 0
        
        selectedKey = "coverup"
        getData(selectedKey: selectedKey)
    }
    
    
    
    
  
    
    //데이터 가져오는 함수 만들어서 viewDidLoad()에서 호출하기
    func getData(selectedKey: String = "lettering"){
        //버튼 선택시 입력되는 selectedKey 값으로 request 날림
        self.selectedKey = selectedKey
        let url = "http:127.0.0.1:1234/api/upload-design/?design_style="
        let doNetwork = Alamofire.request(url+selectedKey)
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                NSLog("통신 성공")
                if let nsArray = obj as? NSArray{       //array 벗김
                    for bundle in nsArray {
                        if let nsDictionary = bundle as? NSDictionary{         //dictionary 벗겨서 튜플에 각 데이터 삽입
                            if let tId = nsDictionary["tatt_id"] as? String, let tDesc = nsDictionary["design_desc"] as? String
                                , let dPhoto = nsDictionary["design_photo"] as? String, let dId = nsDictionary["id"] as? Int{
                                self.dataTuple = (tId, tDesc, dPhoto, dId)   //튜플에 데이터 삽입
                            }
                        }
                    
                        //어레이에 튜플로 이뤄진 값 삽입
                       self.dataArray.insert(self.dataTuple, at: self.num)
                       self.num += 1
                    }
                    //컬렉션뷰 데이터 리로드
                    self.collectionView.reloadData()
                }
            case .failure(let e): //통신 실패
                print(e.localizedDescription)
            }
          
            self.list = {
                  var datalist = [FindStyleVO]()

                  for(tId, tDesc, dPhoto, dId) in self.dataArray{
                      var fvo = FindStyleVO()
                      fvo.tatt_id = tId
                      fvo.design_desc = tDesc
                      fvo.design_photo = "codog.jpeg"
                      fvo.design_id = dId
                                           
                      datalist.append(fvo)
                  }

                  return datalist
              }()
        }
    }
    

    
    

    //셀 몇개나 보여줄건지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        for a in self.list {
            print("list is \(a)")
        }
        NSLog("self.list.count is \(self.list.count)")
        NSLog("self.dataArray.count is \(self.dataArray.count)")
        return self.list.count
    }

    //셀에 내용 삽입
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindStyleCell", for: indexPath) as! FindStyleCell

        cell.tattistId?.text = row.tatt_id
        cell.design.image = UIImage(named: row.design_photo!)
        cell.desc?.text = row.design_desc

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





}//class 





//컬럼 갯수 두개씩 나오도록 사이즈 조정
extension FindStyleViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat = 25
        let collectionCellSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)

    }
    
}
