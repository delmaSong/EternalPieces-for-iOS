//
//  FindStyleCell.swift
//  EternalPieces
//
//  Created by delma on 09/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class FindStyleCell : UICollectionViewCell {
    
    @IBOutlet var design: UIImageView!
    @IBOutlet var tattistId: UILabel!
   
    @IBOutlet var desc: UITextView!
    @IBOutlet var likeBtn: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        design.image = nil
        tattistId.text = nil
        desc.text = nil
        likeBtn.setImage(UIImage(named:"emptyHeart.png"), for: .normal)
    }
    
}
