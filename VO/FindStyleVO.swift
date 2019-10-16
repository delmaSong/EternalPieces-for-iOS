//
//  FindStyleVO.swift
//  EternalPieces
//
//  Created by delma on 09/08/2019.
//  Copyright © 2019 다0. All rights reserved.
// 스타일 찾기 화면에 들어갈 데이터 

import Foundation

struct FindStyleVO: Codable {
    var design_photo: String?              //도안 사진
    var tatt_id: String?           //타티스트 아이디
    var design_desc: String?         //도안 설명
    var design_id: Int?             //도안 아이디
}
