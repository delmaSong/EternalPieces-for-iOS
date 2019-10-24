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
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //들어갈 데이터 셋
    var dataSet = [
        ("9월","10일", "(수)", "14시", "tattoojoha", "안아프게해주세요제바류,,"),
        ("9월","14일", "(일)", "11시", "ttlove", "메시지메시지"),
        ("10월","10일", "(수)", "14시", "tattoojoha", "안아프게해주세요제바류,,"),
        ("10월","14일", "(일)", "11시", "ttlove", "메시지메시지"),
        ("11월","10일", "(수)", "14시", "tattoojoha", "안아프게해주세요제바류,,"),
        ("11월","14일", "(일)", "11시", "ttlove", "메시지메시지")
    ]
    
    lazy var list: [TattistBookingListVO] = {
       var datalist = [TattistBookingListVO]()
        for(month, date, day, time, tattooer, require) in self.dataSet{
            let tvo = TattistBookingListVO()
            tvo.month = month
            tvo.date = date
            tvo.day = day
            tvo.time = time
            tvo.tattooer = tattooer
            tvo.require = require
            
            datalist.append(tvo)
        }
        
        return datalist
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TattistBookingCell") as! TattistBookingListCell
        
        cell.month?.text = row.month
        cell.date?.text = row.date
        cell.day?.text = row.day
        cell.time?.text = row.time
        cell.tattooer?.text = row.tattooer
        cell.require?.text = row.require

        return cell
    }
    
    //해당 셀 클릭시 예약정보 상세화면으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "TattistDetailedBook"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        }
    }
    
}
