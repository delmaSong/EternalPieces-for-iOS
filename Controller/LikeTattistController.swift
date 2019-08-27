//
//  LikeTattistController.swift
//  EternalPieces
//
//  Created by delma on 26/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class LikeTattistController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame = CGRect(x:0, y:self.view.frame.height / 7 + 50, width: self.view.frame.width , height: self.view.frame.height)
        
    }
    
    //컬렉션 셀에 담길 데이터
    var dataSet = [
        ("codog.jpeg","tattistId","tattist self introduce"),
        ("codog.jpeg","타티스트아이디","셀프 간단 소개쓰"),
        ("codog.jpeg","멍냥쓰","tattist self introduce"),
        ("codog.jpeg","멍뭉쓰","tattist self introduce"),
        ("codog.jpeg","더미데이터","tattist self introduce")
        
    ]
    
    lazy var list: [LikeTattistVO] = {
        
        var datalist = [LikeTattistVO]()
        
        for(profile, tattistId, tattistIntro) in self.dataSet{
            let fvo = LikeTattistVO()
            fvo.profile = profile
            fvo.tattistId = tattistId
            fvo.tattistIntro = tattistIntro
            
            datalist.append(fvo)
        }
        return datalist
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = self.list[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeTattistCell", for: indexPath) as! LikeTattistCell
        
        cell.profile.image = UIImage(named: row.profile!)
        cell.tattistId?.text = row.tattistId
//        cell.tattistIntro?.text = row.tattistIntro
        cell.tattistIntro?.text = row.tattistIntro
        
        return cell
    }
    
    //셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
        
        if let lmc = self.storyboard?.instantiateViewController(withIdentifier: "TattistWithTabBar"){
            
            lmc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            self.present(lmc, animated: true)
            
        }
    }
}
