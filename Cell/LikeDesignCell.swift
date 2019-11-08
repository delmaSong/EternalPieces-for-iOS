//
//  LikeDesignCell.swift
//  EternalPieces
//
//  Created by delma on 26/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class LikeDesignCell : UICollectionViewCell{
  
    @IBOutlet var design: UIImageView!
    @IBOutlet var tattistId: UILabel!
    @IBOutlet var decsription: UITextView!
    @IBOutlet var likeBtn: UIButton!
    
    override func prepareForReuse() {
        design.image = nil
        tattistId.text = nil
        decsription.text = nil
        likeBtn.setImage(UIImage(named:"filledHeart.png"), for: .normal)
    }
}
