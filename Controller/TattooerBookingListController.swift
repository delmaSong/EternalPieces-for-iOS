//
//  TattooerBookingListController.swift
//  EternalPieces
//
//  Created by delma on 15/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class TattooerBookingListController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var tableView: UITableView!
    //서버에서 json list 받을 튜플
    var dataTuple : (dPhoto: String, date: String, time: String, place: String, price: String, tId: String, part: String, size: String, comm: String) = ("", "", "", "", "", "", "", "", "")
    //서버에서 json list 받을 어레이
    var dataArray :[(String, String, String, String, String, String, String, String, String)] = []
    //array insert시 사용할 인덱스
    var num:Int = 0
    //테이블뷰에 넣어줄 데이터 리스트
    var list: [TattooerBookingListVO] = []
    
    override func viewDidLoad() {
       getData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //서버에서 타투어의 예약정보 데이터 가져오기
    func getData(){
        let url = "http:127.0.0.1:1234/api/booking/?booker="
        let doNetwork = Alamofire.request(url+"2222")   //로그인된 유저아이디 값 넣기 
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj):
                if let nsArray = obj as? NSArray{
                    for bundle in nsArray {
                        if let nsDictionary = bundle as? NSDictionary{
                            if let dPhoto = nsDictionary["book_photo"] as? String,
                            let date = nsDictionary["book_date"] as? String,
                            let time = nsDictionary["book_time"] as? String,
                            let place = nsDictionary["book_place"] as? String,
                            let price = nsDictionary["book_price"] as? String,
                            let tId = nsDictionary["book_tatt"] as? String,
                            let part = nsDictionary["book_part"] as? String,
                            let size = nsDictionary["book_size"] as? String,
                            let comm = nsDictionary["book_comm"] as? String{
                                self.dataTuple = (dPhoto, date, time, place, price, tId, part, size, comm)   //튜플에 데이터 삽입
                            }//if
                        }//if
                        self.dataArray.insert(self.dataTuple, at:self.num)   //어레이에 튜플로 이뤄진 값 삽입
                        self.num += 1
                    }//for
                   
                }//if
            case .failure(let e):   //통신 실패
                print(e.localizedDescription)
            }//switch
            self.list = {
               var datalist = [TattooerBookingListVO]()
                for(dPhoto, date, time, place, price, tId, part, size, comm) in self.dataArray {
                    var tvo = TattooerBookingListVO()
                    tvo.design = dPhoto
                    tvo.date = date
                    tvo.time = time
                    tvo.address = place
                    tvo.price = price
                    tvo.tattist = tId
                    tvo.bodyPart = part
                    tvo.size = size
                    tvo.request = comm
                    
                    datalist.append(tvo)
                }
                return datalist
            }() //list
            //테이블뷰 데이터 리로드
           self.tableView.reloadData()
        }//doNetwork
    }//getData()
   
    
    
    
    //테이블뷰 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TattooerBookingCell", for: indexPath) as! TattooerBookingListCell
        
        let url = "http:127.0.0.1:1234"
        let imgURL = URL(string:url+row.design!)
        
        cell.design.kf.setImage(with: imgURL)
        cell.date?.text = row.date
        cell.time?.text = row.time
        cell.address?.text = row.address
        cell.price?.text = row.price
        cell.tattist?.text = row.tattist
        cell.bodyPart?.text = row.bodyPart
        cell.size?.text = row.size
        cell.request?.text = row.request
        cell.reviewBtn.tag = indexPath.row
        cell.reviewBtn.addTarget(self, action: #selector(goToReview(_ :)), for: .touchUpInside)
        
        
        return cell
    }
    
  
    @IBAction func goToBookingList(_segue: UIStoryboardSegue){
        
    }
    
   
    
    //리뷰 쓰러 이동
    @objc func goToReview(_ sender: UIButton) {
        let data = self.list[sender.tag]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .getDId, object: data.tattist! ) }
            if let st = self.storyboard?.instantiateViewController(withIdentifier: "UploadReview") as? UploadReviewController{
            st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(st, animated: true)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //옵저버 제거
        NotificationCenter.default.removeObserver(self, name: .getDId, object: nil)
    }
    
    
    
    
}

//옵저버에 이름추가
extension Notification.Name{
    static let getDId = Notification.Name("getDId")
}
