//
//  FindStyleViewController.swift
//  EternalPieces
//
//  Created by delma on 09/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit

class FindStyleViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    var dataSet = [
        ("타티스트Id","도안에 대한 간단한 설명이 들어갈 곳입니다하dddddd","codog.jpeg"),
        ("이진아Id","냠냠냠, 마음대로, everyday 좋아요","codog.jpeg"),
        ("선우정아","구애, 비온다, 고양이,,...","codog.jpeg"),
        ("doitTT","코딩하는 강아지 코독이에욥","codog.jpeg"),
        ("곤니","멍뭉쓰 곤니쓰 말티즈 ","codog.jpeg"),
        ("ㅇㅇㅇㅇㅇ","오늘 저녁은 뭐 먹을가..","codog.jpeg"),
        ("타티스트Id","도안에 대한 간단한 설명이 들어갈 곳입니다하","codog.jpeg"),
        ("타티스트Id","도안에 대한 간단한 설명이 들어갈 곳입니다하","codog.jpeg"),
        ("타티스트Id","도안에 대한 간단한 설명이 들어갈 곳입니다하","codog.jpeg")
    ]
    

    
    lazy var list : [FindStyleVO] = {
       
        var datalist = [FindStyleVO]()
        
        for(tattistId, description, design) in self.dataSet{
            let fvo = FindStyleVO()
            fvo.tattistId = tattistId
            fvo.description = description
            fvo.design = design
            
            datalist.append(fvo)
        }
        
        return datalist
    }()
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindStyleCell", for: indexPath) as! FindStyleCell
        
        cell.tattistId?.text = row.tattistId
        cell.design.image = UIImage(named: row.design!)
//        cell.desc?.text = row.description
        cell.desc?.text = row.description
        

        return cell
    }
    
    //셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "DesignDetailView"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
        }
    }
    
    

   
    
}

//컬럼 갯수 두개씩 나오도록 사이즈 조정
extension FindStyleViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 25
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
        
    }
    
}
