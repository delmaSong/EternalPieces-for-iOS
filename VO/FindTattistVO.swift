//
//  FindTattistVO.swift
//  EternalPieces
//
//  Created by delma on 17/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//타티스트 찾기 화면에 들어갈 데이터

import Foundation

class FindTattistVO :Codable{
    //타티스트 프로필 사진
    var profile: String?
    //타티스트 아이디
    var tattistId: String?
    //타티스트 소개 
    var tattistIntro: String?
    //타티스트 고유 아이디
    var id: String?
    //시술 가능 시간
    var tatt_time: String?
    //시술 가능 요일
    var tatt_date: String?
    //작업물 사진
    var tatt_work: String?
    //시술 장소
    var tatt_addr: String?
    
    
}
