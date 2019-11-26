//
//  ChatTattooerListViewController.swift
//  EternalPieces
//
//  Created by delma on 07/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChatTattooerListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    var chatTuple: (sender: String, reciever: String, msg: String, time: String) = ("", "", "", "")
    var chatRooms: [(String, String, String, String)] = []
    var list: [ChatVO] = []
    
    var uid: String?
    var userId: String?
    var chatRoomIdList: [String] = []
    var dataArray: [String:AnyObject] = [:]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        uid = Auth.auth().currentUser?.uid
       Database.database().reference().child("users").child(self.uid!).observe(.value) { (data) in
           let dataValue = data.value as! Dictionary<String, Any>
           let nick = dataValue["nick"]
           self.userId = nick as? String
            self.getChatRoomList()

       }
       
    }
    
    //채팅방 목록 가져옴
    func getChatRoomList(){
        let db = Database.database().reference()
        db.child("users").child(self.uid!).queryOrdered(byChild: "entry/"+self.userId!).queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                self.chatRoomIdList.append(item.key)
            }
            
            for item in self.chatRoomIdList {
               db.child("chatrooms").child(item).observe(.childAdded) { (snapshot) in
                    
                    if let chatroomDic = snapshot.value as? Dictionary<String, Any>{
                        let reciever = chatroomDic["reciever"]
                        let sender = chatroomDic["sender"]
                        let msg = chatroomDic["msg"]
                        let time = chatroomDic["time"]
                        self.chatTuple = (sender, reciever, msg, time) as! (sender: String, reciever: String, msg: String, time: String)
                    }
                    self.chatRooms.append(self.chatTuple)
                    self.list = {
                         var datalist = [ChatVO]()
                         for (reciever, sender, msg, time) in self.chatRooms{
                             let cvo = ChatVO()
                             cvo.reciever = reciever
                             cvo.sender = sender
                             cvo.msg = msg
                             cvo.time = time
                             
                             datalist.append(cvo)
                         }
                         return datalist
                     }()
                self.tableView.reloadData()
                }
               
            }
        }
    }
    

    
       
    
    
    //MARK: - 테이블뷰 관련 설정
    
    //셀 몇줄 만들건지 지정
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    //셀에 어떤 내용 넣어줄 건지 지정
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatTattooerCell
        
        if row.sender == self.userId!{
            cell.tattistId?.text = row.reciever
        }else{
            cell.tattistId?.text = row.sender
        }
        cell.chatContent?.text = row.msg
        cell.chatTime?.text = row.time
//        cell.profile.image = UIImage(named: row.profile!)
        
        return cell
    }
    
    //해당 셀 클릭시 실행되는 메소드
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.list[indexPath.row]
        if let st = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom") as? ChatController{
            st.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            if row.sender == self.userId!{
                st.reciever = row.reciever!
            }else{
                st.reciever = row.sender!
            }
            self.present(st, animated: true)
       }
    }
    
    
    
    
    
    
}
