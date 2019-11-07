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
import Kingfisher

class FindStyleViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    var selectedKey = ""    //버튼 선택시 서버 넘길 키워드
    
    //서버에서 json list 받을 튜플
    var dataTuple : (tId: String, dDesc: String, dPhoto: String, dId: Int) = ("", "", "", 0)
    //서버에서 json list 받을 어레이. 어레이 속에 튜플 들어간 구조
    var dataArray :[(String, String, String, Int)] = []
    //어레이 인서트시 사용할 인덱스
    var num:Int = 0
    //컬렉션뷰에 넣어줄 데이터 리스트
    var list: [FindStyleVO] = []



    var likeArray: [String] = []        //좋아하는 도안 아이디 담을 어레이
    
    override func viewDidLoad() {
        //도안 스타일에 따른 데이터 가져오기
        getData()
        collectionView.delegate = self
        collectionView.dataSource = self
        //좋아요 정보 가져오기
        getLikeData()

    }
    
    
    
    
    // MARK: - 상단 스타일 버튼 기능 분기
    
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
    
    
    
    //데이터 가져오는 함수 만들어서 viewDidLoad()에서 호출하기
    func getData(selectedKey: String = "lettering"){
        //버튼 선택시 입력되는 selectedKey 값으로 request 날림
        self.selectedKey = selectedKey
        let url = "http:127.0.0.1:1234/api/upload-design/?design_style="
        let doNetwork = Alamofire.request(url+selectedKey)
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
                       self.dataArray.insert(self.dataTuple, at: self.num)
                       self.num += 1
                    }
                }
            case .failure(let e): //통신 실패
                print(e.localizedDescription)
            }
          
            //컬렉션셀에 넣어줄 데이터 준비
            self.list = {
                  var datalist = [FindStyleVO]()

                  for(tId, dDesc, dPhoto, dId) in self.dataArray{
                      var fvo = FindStyleVO()
                      fvo.tatt_id = tId
                      fvo.design_desc = dDesc
                      fvo.design_photo = dPhoto
                      fvo.design_id = dId
                                           
                      datalist.append(fvo)
                  }

                  return datalist
              }()
            //컬렉션뷰 데이터 리로드
           self.collectionView.reloadData()
        }
    }
    

    
    
//MARK: - 컬렉션뷰 설정
    //셀 몇개나 보여줄건지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.list.count
    }

    //셀에 내용 삽입
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindStyleCell", for: indexPath) as! FindStyleCell

        let imgURL = URL(string: row.design_photo!)
       
        //각 셀에 데이터 삽입
        cell.tattistId?.text = row.tatt_id
        cell.design.kf.setImage(with:imgURL)    //킹피셔 이용한 이미지 삽입
//        cell.desc?.layer.borderColor = UIColor.gray.cgColor
//        cell.desc?.layer.borderWidth = 0.5
        cell.desc?.text = row.design_desc
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(doLike(_:)), for: .touchUpInside)
        

        //좋아요 배열에 포함되어있다면 버튼 색상 변경
        if self.likeArray.contains(String(row.design_id!)){
            cell.likeBtn.setImage(UIImage(named:"filledHeart.png"), for: .normal)
        }
        return cell
    }

    
    
    //셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = self.list[indexPath.row]
        
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "DesignDetailView") as? DesignDetailController{
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            //도안 id값 전달
            lmc.designId = row.design_id!
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



}//class





//컬럼 갯수 두개씩 나오도록 사이즈 조정
extension FindStyleViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat = 25
        let collectionCellSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)

    }
    
}
