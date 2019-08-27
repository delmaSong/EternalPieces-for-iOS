//
//  ViewController.swift
//  EternalPieces
//
//  Created by 다0 on 16/07/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var findStyle: UIButton!
    @IBOutlet var findTattist: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func gotoMain(_segue: UIStoryboardSegue){
       
    }


    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToSecondTabBar"{
            if let destVC = segue.destination as? FindTabBarController{
                destVC.selectedIndex = 1
            }
        }
    }




}

