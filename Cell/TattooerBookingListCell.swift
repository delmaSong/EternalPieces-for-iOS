//
//  TattooerBookingListCell.swift
//  EternalPieces
//
//  Created by delma on 15/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//


import UIKit

class TattooerBookingListCell: UITableViewCell{

    //도안 이미지
    @IBOutlet var design: UIImageView!
    
    //시술 날짜
    @IBOutlet var date: UILabel!
    
    //시술 시간
    @IBOutlet var time: UILabel!
    
    //시술 장소
    @IBOutlet var address: UILabel!
    
    //총 결제금액
    @IBOutlet var price: UILabel!
    
    //시술 타티스트
    @IBOutlet var tattist: UILabel!
    
    //부위
    @IBOutlet var bodyPart: UILabel!
    
    //크기
    @IBOutlet var size: UILabel!
    
    //요청사항
    @IBOutlet var request: UILabel!
}
