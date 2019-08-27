//
//  TattistDetailedBook.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//
/*타티스트가 볼 수 있는 예약 상세 현황 */

import Foundation
import UIKit
class TattistDetailedBookController: UIViewController{
    
    //예약 상세 현황의 데이터 받아올 수 있도록 VO파일 생성 및 여기서 구현 필요
  
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}
