//
//  UploadReviewController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit
class UploadReviewController: UIViewController{
    
    //제목
    @IBOutlet var reviewTitle: UITextField!
    
    //내용
    @IBOutlet var contents: UITextView!
    
    override func viewDidLoad() {
        self.contents.layer.borderWidth = 0.5
        self.contents.layer.borderColor = UIColor.gray.cgColor
    }
    
    
}
