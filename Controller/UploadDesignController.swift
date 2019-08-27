//
//  UploadDesignController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class UploadDesignController: UIViewController{
    
    //도안 소개
    
    @IBOutlet var desc: UITextView!
    
    override func viewDidLoad() {
        //텍스트필드 선 두께, 컬러, 굴곡 설정
        self.desc.layer.borderWidth = 0.5
        self.desc.layer.borderColor = UIColor.gray.cgColor
        self.desc.layer.cornerRadius = 0.5
    
        
        
    }
}
