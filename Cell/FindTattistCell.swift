//
//  FindTattistCell.swift
//  EternalPieces
//
//  Created by delma on 17/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit

class FindTattistCell: UICollectionViewCell{
    
    //타티스트 프로필 이미지
    @IBOutlet var profile: UIImageView!
    //타티스트 아이디
    @IBOutlet var tattistId: UILabel!
    //타티스트 셀프 간단소개
    @IBOutlet var tattistIntro: UILabel!
    
    @IBOutlet var likeBtn: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profile.image = nil
        tattistId.text = nil
        tattistIntro.text = nil
        likeBtn.setImage(UIImage(named:"emptyHeart.png"), for: .normal)
    }
}
