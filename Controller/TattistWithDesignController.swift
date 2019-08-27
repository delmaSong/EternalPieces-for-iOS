//
//  TattistWithDesignController.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class TattistWithDesignController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    var dataSet = ["codog.jpeg","codog.jpeg","codog.jpeg","codog.jpeg"]
    
    lazy var list : [TattistWithDesignVO] = {
       
        var datalist = [TattistWithDesignVO]()
        
        for design in self.dataSet{
            let tvo = TattistWithDesignVO()
            tvo.design = design
            
            datalist.append(tvo)
        }
        
        return datalist
    }()
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TattistWithDesignCell", for: indexPath) as! TattistWithDesignCell
        
        cell.design.image = UIImage(named: row.design!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "DesignDetailView"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        }
    }
}

//컬럼 갯수 세개씩 나오도록 사이즈 조정
extension TattistWithDesignController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 20
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/3, height: collectionCellSize/3)
        
    }
    
}
