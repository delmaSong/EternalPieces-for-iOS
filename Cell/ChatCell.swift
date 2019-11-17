//
//  ChatCell.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//  채팅방의 메시지 셀 

import Foundation
import UIKit
class ChatCell: UITableViewCell{
    
    //메시지 내용
    @IBOutlet var msg: UILabel!
    //발신 시간
    @IBOutlet var time: UILabel!
    @IBOutlet var sender: UILabel!
    @IBOutlet var msgBackground: UIView!
    
}

class DestinationCell: UITableViewCell{
    @IBOutlet var msg: UILabel!
    @IBOutlet var time: UILabel!
    
}
