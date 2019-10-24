//
//  TattistBookingListVO.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation

struct TattistBookingListVO: Codable{

    //시술 요일
    var date: String?
    //시술 시간
    var time: String?
    //예약자 아이디
    var tattooer: String?
    //요청사항 
    var require: String?
}
