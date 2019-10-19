//
//  DesignVO.swift
//  EternalPieces
//
//  Created by delma on 02/10/2019.
//  Copyright © 2019 다0. All rights reserved.
//
// 서버에서 데이터 가져올 때 이용할 도안 구조체 

import Foundation

struct DesignVO: Codable{
    var id: Int?
    var design_name: String?
    var design_price: Int?
    var design_size: Int?
    var design_spent_time: Int?
    var design_style: String?
    var design_desc: String?
    var tatt_id: String?
    var design_photo: String?
}
