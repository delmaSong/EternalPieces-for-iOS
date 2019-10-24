//
//  TattistBookingListCell.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class TattistBookingListCell : UITableViewCell{
    
    /*타티스트의 예약목록 씬의 테이블 셀*/
    
    //예약일
    @IBOutlet var date: UILabel!
    //예약 시간
    @IBOutlet var time: UILabel!
    //예약자 아이디
    @IBOutlet var tattooer: UILabel!
    //요청사항
    @IBOutlet var require: UILabel!
    
}
