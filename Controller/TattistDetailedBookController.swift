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
import Kingfisher

class TattistDetailedBookController: UIViewController{
    
    var booker:String = ""
    var date: String = ""
    var book_time: String = ""
    var book_price: String = ""
    var book_part: String = ""
    var book_size: String = ""
    var book_comm: String = ""
    var design_photo: String = ""
  

    
    @IBOutlet var lbBooker: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var lbPrice: UILabel!
    @IBOutlet var lbPart: UILabel!
    @IBOutlet var lbSize: UILabel!
    @IBOutlet var lbComm: UILabel!
    @IBOutlet var photo: UIImageView!
    
    override func viewDidLoad() {
        self.lbBooker.text = booker
        self.lbTime.text = book_time
        self.lbPrice.text = book_price
        self.lbPart.text = book_part
        self.lbSize.text = book_size
        self.lbComm.text = book_comm
        
        let url = "http:127.0.0.1:1234"
       let imgURL = URL(string:url+design_photo)
           
        self.photo.kf.setImage(with: imgURL)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}
