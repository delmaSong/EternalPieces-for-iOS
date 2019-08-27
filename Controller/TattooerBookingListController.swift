//
//  TattooerBookingListController.swift
//  EternalPieces
//
//  Created by delma on 15/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit

class TattooerBookingListController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var dataSet = [
        ("codog.jpeg","2019년 10월 14일 (수)", "13시", "서울시 마포구 연남동 123", "12", "tattist_ok", "팔 상단", "7", "아프지 않게 해주세요"),
        ("garbage.jpg","2019년 11월 4일 (수)", "18시", "서울시 용산구 이태원동 321", "23", "tattist_ii", "종아리", "15", "아프지 않게 해주세요")
    ]
    
    lazy var list: [TattooerBookingListVO] = {
       var datalist = [TattooerBookingListVO]()
        for(design, date, time, address, price, tattist, bodyPart, size, request) in self.dataSet {
            let tvo = TattooerBookingListVO()
            tvo.design = design
            tvo.date = date
            tvo.time = time
            tvo.address = address
            tvo.price = price
            tvo.tattist = tattist
            tvo.bodyPart = bodyPart
            tvo.size = size
            tvo.request = request
            
            datalist.append(tvo)
            
        }
        
        return datalist
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TattooerBookingCell") as! TattooerBookingListCell
        
        cell.design.image = UIImage(named: row.design!)
        cell.date?.text = row.date
        cell.time?.text = row.time
        cell.address?.text = row.address
        cell.price?.text = row.price
        cell.tattist?.text = row.tattist
        cell.bodyPart?.text = row.bodyPart
        cell.size?.text = row.size
        cell.request?.text = row.request
        
        return cell
    }
    
  
    @IBAction func goToBookingList(_segue: UIStoryboardSegue){
        
    }
}
