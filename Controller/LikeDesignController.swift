//
//  LikeDesignController.swift
//  EternalPieces
//
//  Created by delma on 26/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class LikeDesignController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame = CGRect(x:0, y:self.view.frame.height / 7 + 50, width: self.view.frame.width , height: self.view.frame.height)
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
    
    
    
    lazy var list : [LikeDesignVO] = {
        
        var datalist = [LikeDesignVO]()
        
        for(tattistId, description, design) in self.dataSet{
            let fvo = LikeDesignVO()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeDesignCell", for: indexPath) as! LikeDesignCell
        
        cell.tattistId?.text = row.tattistId
        cell.design.image = UIImage(named: row.design!)
        cell.decsription?.text = row.description
        
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
