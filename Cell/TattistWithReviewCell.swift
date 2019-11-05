//
//  TattistWithReviewCell.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class TattistWithReviewCell: UITableViewCell{
    
    @IBOutlet var title: UILabel!
    @IBOutlet var contents: UITextView!
    @IBOutlet var writer: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!
    let ratingvar: CosmosView = CosmosView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contents.isEditable = false 
        let colorli = #colorLiteral(red: 0.394319929, green: 0.536441238, blue: 0.6976721129, alpha: 1)
        //별점바 세팅
        self.ratingvar.frame = CGRect(x: contentView.frame.width-120, y:10, width: 40, height: 25)
        self.ratingvar.settings.fillMode = .half
        self.ratingvar.settings.emptyBorderColor = colorli  //색상 결정
        self.ratingvar.settings.filledColor = colorli
        self.ratingvar.settings.filledBorderColor = colorli
        self.ratingvar.settings.updateOnTouch = false
        self.ratingvar.settings.starMargin = 0.2
        contentView.addSubview(ratingvar)
    }
    

}
