//
//  TattooerBookingListVO.swift
//  EternalPieces
//
//  Created by delma on 15/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation

struct TattooerBookingListVO: Codable {
    var design: String?         //도안 이미지
    var date: String?            //시술 날짜
    var time: String?            //시술 시간
    var address: String?        //시술 장소
    var price: String?              //결제금액
    var tattist: String?        //시술하는 타티스트
    var bodyPart: String?       //시술 부위
    var size: String?              //시술 사이즈
    var request: String?        //요청사항
    
}
