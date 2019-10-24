//
//  TattistBookingListController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//
/* 타티스트 예약 목록*/

import Foundation
import UIKit
import Alamofire

class TattistBookingListController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var tableView: UITableView!
    //서버에서 json list 받을 튜플
    var dataTuple : (date: String, time: String, booker: String, comm: String, price: String, part: String, size: String, photo: String) = ("", "", "", "", "", "", "", "")
    //서버에서 json list 받을 어레이
    var dataArray : [(String, String, String, String, String, String, String, String)] = []
    //array insert시 사용할 인덱스
    var num:Int = 0
    //테이블뷰에 넣어줄 데이터 리스트
    var list: [TattooerBookingListVO] = []
    
    override func viewDidLoad() {
        getData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //서버에서 타티스트 예약정보 가져오기
    func getData(){
        let url = "http:127.0.0.1:1234/api/booking/?book_tatt="
        let doNetwork = Alamofire.request(url+"1111")       //로그인된 유저 아이디값 넣기
        doNetwork.responseJSON{(response) in
            switch response.result{
            case .success(let obj): //통신 성공
                if let nsArray = obj as? NSArray{
                    for bundle in nsArray{
                        if let nsDictionary = bundle as? NSDictionary{
                            if let date = nsDictionary["book_date"] as? String,
                            let time = nsDictionary["book_time"] as? String,
                            let booker = nsDictionary["booker"] as? String,
                                let comm = nsDictionary["book_comm"] as? String,
                            let price = nsDictionary["book_price"] as? String,
                            let part = nsDictionary["book_part"] as? String,
                            let size = nsDictionary["book_size"] as? String,
                            let photo = nsDictionary["book_photo"] as? String{
                                //튜플에 데이터 삽입
                                self.dataTuple = (date, time, booker, comm, price, part, size, photo)
                            }//if
                        }//if
                        //어레이에 튜플로 이뤄진 값 삽입
                        self.dataArray.insert(self.dataTuple, at:self.num)
                        self.num += 1
                    }//for
                }//if
            case .failure(let e):   //통신 실패
                print(e.localizedDescription)
            }//switch
            self.list = {
               var datalist = [TattooerBookingListVO]()
                for(date, time, booker, comm, price, part, size, photo) in self.dataArray{
                    var tvo = TattooerBookingListVO()
                    tvo.date = date
                    tvo.time = time
                    tvo.tattooer = booker
                    tvo.request = comm
                    tvo.price = price
                    tvo.bodyPart = part
                    tvo.size = size
                    tvo.design = photo
                    
                    datalist.append(tvo)
                }
                
                return datalist
            }()//list
            //테이블뷰 데이터 리로드
            self.tableView.reloadData()
            print("tuple is \(self.dataTuple)")
        }//donetwork
    }//func
    
 
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TattistBookingCell") as! TattistBookingListCell
        
        cell.date?.text = row.date
        cell.time?.text = row.time
        cell.tattooer?.text = row.tattooer
        cell.require?.text = row.request

        return cell
    }
    
    //해당 셀 클릭시 예약정보 상세화면으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "TattistDetailedBook") as? TattistDetailedBookController{
            
            let row = self.list[indexPath.row]
            
            //예약 상세 화면으로 데이터 전달
            lmc.booker = row.tattooer!
            lmc.date = row.date!
            lmc.book_time = row.time!
            lmc.book_price = row.price!
            lmc.book_part = row.bodyPart!
            lmc.book_size = row.size!
            lmc.book_comm = row.request!
            lmc.design_photo = row.design!
            
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical

            self.present(lmc, animated: true)
        }
    }
    
}
