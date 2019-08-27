//
//  ChatTattooerListViewController.swift
//  EternalPieces
//
//  Created by delma on 07/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
import UIKit


class ChatTattooerListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
   
    override func viewDidLoad() {
       // super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    var dataSet = [
        ("타투이스트요홍", "안녕하세요 이 타투 받고싶은데요~~~", "14:09", "codog.jpeg"),
        ("가나다라", "다음은 아자차카 입니다", "14:09", "ep_icon.png"),
        ("소나무", "대표적인 침엽수이고, 열매는 잣", "15:09", "codog.jpeg"),
        ("진달래", "철쭉과 비슷하게 생겼지요 ㅎ ㅎㅎ ", "11:09", "ep_icon.png"),
        ("강낭콩", "완두콩 병아리콩 땅콩 ", "14:03", "codog.jpeg"),
        ("송곤니", "멍 멍멍!!멍머머머멍멍멍!!멍!", "22:09", "ep_icon.png"),
        ("타티스트", "타투이스트 타티스트 타타타티티티", "11:42", "codog.jpeg"),
        ("가나다라", "다음은 아자차카 입니다", "14:09", "ep_icon.png"),
        ("소나무", "대표적인 침엽수이고, 열매는 잣", "15:09", "codog.jpeg"),
        ("진달래", "철쭉과 비슷하게 생겼지요 ㅎ ㅎㅎ ", "11:09", "ep_icon.png"),
        ("강낭콩", "완두콩 병아리콩 땅콩 ", "14:03", "codog.jpeg"),
        ("송곤니", "멍 멍멍!!멍머머머멍멍멍!!멍!", "22:09", "ep_icon.png"),
        ("타티스트", "타투이스트 타티스트 타타타티티티", "11:42", "codog.jpeg")
    ]
    
    lazy var list: [ChatTattooerVO] = {
        var datalist = [ChatTattooerVO]()
        for (others, contents, time, profile) in self.dataSet{
            let cvo = ChatTattooerVO()
            cvo.others = others
            cvo.contents = contents
            cvo.time = time
            cvo.profile = profile
            
            datalist.append(cvo)
        }
        return datalist
    }()
    
    //셀 몇줄 만들건지 지정
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    //셀에 어떤 내용 넣어줄 건지 지정
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatTattooerCell
        
        cell.tattistId?.text = row.others
        cell.chatContent?.text = row.contents
        cell.chatTime?.text = row.time
        cell.profile.image = UIImage(named: row.profile!)
        
        return cell
    }
    
    //해당 셀 클릭시 실행되는 메소드
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
        
        if let st = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom"){
            
                        st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
                        self.present(st, animated: true)
                    }
    }
}
