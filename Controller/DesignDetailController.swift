//
//  DesignDetailController.swift
//  EternalPieces
//
//  Created by delma on 11/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class DesignDetailController: UIViewController {
    
    
    //상단에 보이는 타티스트 아이디
    @IBOutlet var tattistId1: UILabel!
    //중앙에 담기는 타티스트 아이디
    @IBOutlet var tattistId2: UILabel!
    //도안 이미지
    @IBOutlet var design: UIImageView!
    //타티스트 프로필 이미지
    @IBOutlet var profile: UIImageView!
    //도안 이름
    @IBOutlet var designName: UILabel!
    //도안 기준 사이즈
    @IBOutlet var size: UILabel!
    //도안 가격
    @IBOutlet var price: UILabel!
    //소요 시간
    @IBOutlet var spentTime: UILabel!
    
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
