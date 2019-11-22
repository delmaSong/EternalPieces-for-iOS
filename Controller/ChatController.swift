//
//  ChatController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//  채팅방 컨트롤러 

import UIKit
import Firebase
import SVProgressHUD
class ChatController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var back: UIButton!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var msgField: UITextField!
    @IBOutlet var recieverTitle: UILabel!
    
    var msgArr: [ChatVO] = [ChatVO]()
    var reciever: String = ""
    var chatRoomId: String = ""
    var uid: String?
    
    override func viewDidLoad() {
    
        uid = Auth.auth().currentUser?.uid
        
        recieverTitle.text = reciever
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        //테이블뷰쪽 누르면 텍스트 쓰는거 그만
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
        configureTableView()
        
        checkChatRoom()
        print("\((Auth.auth().currentUser?.email)!)")
        print("\(self.reciever)")
//       retrieveMessages()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.msgArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if self.msgArr[indexPath.row].sender == Auth.auth().currentUser?.email as String?{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
               cell.msg?.text = self.msgArr[indexPath.row].msg
               cell.time?.text = self.msgArr[indexPath.row].time
               cell.sender?.text = self.msgArr[indexPath.row].sender
               cell.sender.isHidden = true
            return cell
       }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell") as! DestinationCell
              cell.msg?.text = self.msgArr[indexPath.row].msg
              cell.time?.text = self.msgArr[indexPath.row].time
            return cell
       }
    }
    
    
    //touch back button
    @IBAction func goBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func tableViewTapped(){
        msgField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func doSend(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        msgField.endEditing(true)
        msgField.isEnabled = false
        sendBtn.isEnabled = false
        let db = Database.database().reference().child("chatrooms")

        if self.chatRoomId == "" {
            let createRoomInfo: Dictionary<String, Any> = ["users": [ "senderId" : "aaa",
                                                                      "recieverId" : self.reciever] ]
            db.childByAutoId().setValue(createRoomInfo)
            print("chatroom created")
        }else{
            let msgDict = ["sender" : Auth.auth().currentUser?.email,
                           "msg" : msgField.text!,
                           "time" : formatter.string(from:Date()),
                           "reciever" : self.reciever]
            db.child(self.chatRoomId).child("message").childByAutoId().setValue(msgDict){(error, reference) in
                if error != nil{
                    print(error!)
                }
            }
        }
        self.msgField.isEnabled = true
       self.sendBtn.isEnabled = true
       self.msgField.text = ""
        
    }
    
    //셀 크기 조정
    func configureTableView(){
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func retrieveMessages(){
        //기존 저장된 메시지 있다면 가져와 
        if self.chatRoomId != "" {
            SVProgressHUD.show()
            let msgDB = Database.database().reference().child("chatrooms").child(self.chatRoomId).child("message")
            msgDB.observe(.childAdded){
                (snapshot) in
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                let text = snapshotValue["msg"]!
                let sender = snapshotValue["sender"]!
                let time = snapshotValue["time"]
                let reciever = snapshotValue["reciever"]
                
                if sender == Auth.auth().currentUser?.email && reciever == self.reciever {
                    let message = ChatVO()
                    message.msg = text
                    message.sender = sender
                    message.time = time
                    message.reciever = reciever
                    
                    self.msgArr.append(message)
                    self.configureTableView()
                    self.tableView.reloadData()
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    

  
    //해당 유저들의 채팅방이 있는지 확인.
    func checkChatRoom(){
        let db = Database.database().reference()
        print("chat room exist")
        //users 아래에 현재 로그인한 유저의 채팅방 가져옴
        db.child("chatrooms").queryOrdered(byChild: "users/senderId")
          .queryEqual(toValue: "aaa").observeSingleEvent(of: DataEventType.value) { (dataSnapShot) in
            
            print("sender id is aaa 의 대화방 id ")
               for item in dataSnapShot.children.allObjects as! [DataSnapshot]{ //모든 id 가져올때
                //reciever == true 인 id를 self.chatRoomId 에 넣어줌
                
                db.child("chatrooms").queryOrdered(byChild: "users/recieverId").queryEqual(toValue: self.reciever).observeSingleEvent(of: .value) { (data) in
                    self.chatRoomId = item.key
                    print("self.chatRoomId is \(self.chatRoomId)")
                    print("sender is aaa and reciever is \(self.reciever)")
                    self.retrieveMessages()
                }
                  
              
                    
                
                    
               }
            }
        
       
        
        
        }
    
    
    
    
    
}
