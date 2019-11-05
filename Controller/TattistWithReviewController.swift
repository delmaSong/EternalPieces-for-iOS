//
//  TattistWithReviewController.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class TattistWithReviewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    //서버에서 json list  받을 튜플
    var dataTuple : (rTitle: String, rContents: String ,rWriter: String, rDate: String, rPhoto: String, rRate: String) = ("", "", "", "", "", "")
    //서버에서 json list 받을 어레이.
    var dataArray : [(String, String, String, String, String, String)] = []
    //어레이 인서트시 사용할 인덱스
    var num: Int = 0
    //컬렉션뷰에 넣어줄 데이터 리스트
    var list: [TattistWithReviewVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getReviewData), name: .getReviewData, object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          //기존 어레이 삭제 for 중복제거
          self.dataArray.removeAll()
      }
    
    
    @objc func getReviewData(_ notification: Notification){
        let tattId = notification.object as! String
        let url = "http:127.0.0.1:1234/api/review/?rv_tatt="
        let doNetwork = Alamofire.request(url + tattId)
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                  if let nsArray = obj as? NSArray{       //어레이 벗기면 딕셔너리
                        for bundle in nsArray{
                            if let nsDictionary = bundle as? NSDictionary{
                                //dictionary 벗겨서 튜플에 각 데이터 삽입
                                if let rTitle = nsDictionary["rv_title"] as? String,
                                    let rContents = nsDictionary["rv_contents"] as? String,
                                    let rWriter = nsDictionary["rv_writer"] as? String,
                                    let rDate = nsDictionary["rv_date"] as? String,
                                    let rPhoto = nsDictionary["rv_photo"] as? String,
                                    let rRate = nsDictionary["rv_rate"] as? String {
                                    self.dataTuple = (rTitle, rContents, rWriter, rDate, rPhoto, rRate)   //튜플에 데이터삽입
                                }
                            }
                            
                            //어레이에 튜플로 이뤄진 값 삽입
                            self.dataArray.insert(self.dataTuple, at: self.num)
                            self.num += 1
                        }
                    }
            case .failure(let e):
                print(e.localizedDescription)
            }
            //테이블셀에 넣어줄 데이터 준비
              self.list = {
                 var datalist = [TattistWithReviewVO]()
                  
                  for(rTitle, rContents, rWriter, rDate, rPhoto, rRate) in self.dataArray{
                      var tvo = TattistWithReviewVO()
                    tvo.title = rTitle
                    tvo.contents = rContents
                    tvo.writer = rWriter
                    tvo.date = rDate
                    tvo.img1 = rPhoto
                    tvo.rate = rRate
                      
                      datalist.append(tvo)
                  }
                  return datalist
              }()
            //테이블뷰 데이터리로드 
            self.tableView.reloadData()
        }
        self.num = 0
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TattistWithReviewCell") as! TattistWithReviewCell
        
        cell.title?.text = row.title
        cell.contents?.text = row.contents
        cell.writer?.text = row.writer
        cell.date?.text = row.date
        cell.ratingvar.rating = Double(row.rate!)!
        cell.img1.kf.setImage(with: URL(string:row.img1!))
//        cell.img1.image = UIImage(named: row.img1!)
//        cell.img2.image = UIImage(named: row.img2!)
//        cell.img3.image = UIImage(named: row.img3!)
    
        return cell
    }
    
    
 
    
}
