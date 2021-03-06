//
//  LikeTattistCell.swift
//  EternalPieces
//
//  Created by delma on 26/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class LikeTattistCell : UICollectionViewCell{
    
    @IBOutlet var profile: UIImageView!
    @IBOutlet var tattistId: UILabel!
    @IBOutlet var tattistIntro: UITextView!
    @IBOutlet var likeBtn: UIButton!
    
    override func prepareForReuse() {
        profile.image = nil
        tattistId.text = nil
        tattistIntro.text = nil
        likeBtn.setImage(UIImage(named:"filledHeart.png"), for: .normal)
    }
}
