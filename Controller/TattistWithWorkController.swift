//
//  TattistWithWorkController.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class TattistWithWorkController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
   
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    var dataSet = ["codog.jpeg","dawn.png","codog.jpeg","waterfall.png","codog.jpeg","waterfall.png"]
    
    lazy var list : [TattistWithWorkVO] = {
        
        var datalist = [TattistWithWorkVO]()
        
        for work in self.dataSet{
            let tvo = TattistWithWorkVO()
            tvo.work = work
            
            datalist.append(tvo)
        }
        
        return datalist
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TattistWithWorkCell", for: indexPath) as! TattistWithWorkCell
        
        cell.work.image = UIImage(named: row.work!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
    }
    
}

//컬럼 갯수 세개씩 나오도록 사이즈 조정
extension TattistWithWorkController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 20
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/3, height: collectionCellSize/3)
        
    }
    
}
