//
//  ChatTattooerListViewController.swift
//  EternalPieces
//
//  Created by delma on 07/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Firebase

class ChatTattooerListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    var chatRooms: [ChatVO] = []
    var user: String!
    var dataArray: [String:AnyObject] = [:]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        self.user = Auth.auth().currentUser?.email
            getChatRoomList()
       
    }
    
    //채팅방 목록 가져옴
    func getChatRoomList(){
//        let roomDB = Database.database().reference().child("chatrooms")
//
//        roomDB.queryOrdered(byChild: "users/"+user).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (dataSnapshot) in
//            for item in dataSnapshot.children.allObjects as! [DataSnapshot]{
//                if let chatroomDic = item.value as? [String:AnyObject]{
//                    let chatModel = ChatVO(from: chatroomDic)
//                    self.chatrooms.append(chatModel!)
//                    for _ in chatroomDic.keys{
//                        self.dataArray.updateValue(chatroomDic.values, forKey: chatroomDic.keys)
//                    }
//                    print("chatroomDic is \(chatroomDic)")
//                }
//            }
//        }
//
        
        let db = Database.database().reference()
        db.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.hasChild("chatrooms"){  //대화중인 채팅방 하나라도 있으면
                print("chatrooms exist")
                db.child("chatrooms").queryOrdered(byChild: "users/"+self.user).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                    for item in snapshot.children.allObjects as! [DataSnapshot]{
                        if let chatroomDic = item.value as? [String:AnyObject]{
                        }
                    }
                }
            }else{      //대화중인 채팅방 하나도 없으면
                print("chatrooms doesn't exist")
            }
        }
        
        
    }
    
    var dataSet = [
        ("타투이스트요홍", "안녕하세요 이 타투 받고싶은데요~~~", "14:09", "codog.jpeg"),
        ("가나다라", "다음은 아자차카 입니다", "14:09", "ep_icon.png"),
        ("소나무", "대표적인 침엽수이고, 열매는 잣", "15:09", "codog.jpeg")
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
        return self.chatRooms.count
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
        if let st = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom"){
            st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(st, animated: true)
       }
    }
    
    
    
    
    
    
}
