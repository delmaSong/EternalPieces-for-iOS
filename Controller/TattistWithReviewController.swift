//
//  TattistWithReviewController.swift
//  EternalPieces
//
//  Created by delma on 24/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
class TattistWithReviewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var dataSet = [
        ("리뷰 제목 ", "리뷰 내용", "작성자", "작성날짜", "codog.jpeg", "codog.jpeg", "codog.jpeg"),
        ("너무 맘에들어요", "아주 예쁘고 맘에 들어요 감사합니다~~", "송곤니", "12/11", "codog.jpeg", "codog.jpeg", "codog.jpeg"),
        ("진짜 아팠지만..", "예쁘니까 참는다..^_^", "진달래", "01/23", "codog.jpeg", "codog.jpeg", "codog.jpeg"),
        ("리뷰 제목 ", "리뷰 내용", "작성자", "작성날짜", "codog.jpeg", "codog.jpeg", "codog.jpeg")
    ]
    
    lazy var list : [TattistWithReviewVO] = {
            var datalist = [TattistWithReviewVO]()
        for (title, contents, writer, date, img1, img2, img3) in self.dataSet{
            let tvo = TattistWithReviewVO()
            tvo.title = title
            tvo.contents = contents
            tvo.writer = writer
            tvo.date = date
            tvo.img1 = img1
            tvo.img2 = img2
            tvo.img3 = img3
            
            datalist.append(tvo)
        }
        
        return datalist
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TattistWithReviewCell") as! TattistWithReviewCell
        
        cell.title?.text = row.title
        cell.contents?.text = row.contents
        cell.writer?.text = row.writer
        cell.date?.text = row.date
        cell.img1.image = UIImage(named: row.img1!)
        cell.img2.image = UIImage(named: row.img2!)
        cell.img3.image = UIImage(named: row.img3!)
    
        return cell
    }
    
    
}
