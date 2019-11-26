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
    var userId: String?
    var everFirstChat: Bool = false
    var firstChat: Bool = false
    var chatWithPartner: Bool = false   //해당 상대방과의 생성된 채팅룸 유무 확인
    
    override func viewDidLoad() {
    
        uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(self.uid!).observe(.value) { (data) in
            let dataValue = data.value as! Dictionary<String, Any>
            let nick = dataValue["nick"]
            self.userId = nick as? String
            
        }
        
        
            
        recieverTitle.text = reciever
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        //테이블뷰쪽 누르면 텍스트 쓰는거 그만
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
        configureTableView()
        
        print("\((Auth.auth().currentUser?.email)!)")
        print("\(self.reciever)")

        checkFirstChat()
    }
    
    
    //첫 대화 여부 확인
    func checkFirstChat(){
        //해당 유저 아이디로 chatroom 생성 유무 확인해야함
        let db = Database.database().reference().child("users").child(self.uid!)

        db.queryOrdered(byChild: "entry/"+self.reciever).queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            print("snapshot is \(snapshot)")
            if snapshot.hasChildren() { //누구든지와 채팅 한번은 했을 때
                print("has children~~")
                //상대방과 함께한 채팅룸 있으면 가져옴
                db.queryOrdered(byChild: "entry/"+self.reciever).queryEqual(toValue: true).observeSingleEvent(of: .value) { (data) in
                    for item in data.children.allObjects as! [DataSnapshot]{
                        self.chatRoomId = item.key
                        print("self.chatRoomId is \(self.chatRoomId)")
                        //상대방과의 대화가 처음이면 채팅방 생성하도록 플래그 변경
                        if self.chatRoomId == "" {
                            print("chatroom is ...")
                            self.firstChat = true
                        }else{  //대화 처음 아니면 기존 대화 메시지 가져옴
                            print("chatroom id exist")
                            self.retrieveMsg()
                        }
                    }
                }

                

            }else{  //채팅 누구와도 전혀 안했을 때
                print("no child")
                self.everFirstChat = true

            }
        }
        
    }
    
    func makeChatrooms(){
        print("chat rooms made~!~!~!")
        let formatter = DateFormatter()
         formatter.dateFormat = "HH:mm"
  
         msgField.endEditing(true)
         msgField.isEnabled = false
         sendBtn.isEnabled = false
      
        let msgDict = ["sender" : self.userId!,
                        "msg" : msgField.text!,
                        "time" : formatter.string(from:Date()),
                        "reciever" : self.reciever]
        //chatrooms 아래에 오토아이디로 메시지 붙임
        let chatroomId = Database.database().reference().child("chatrooms").childByAutoId()
        chatroomId.child("message").setValue(msgDict)
        
        self.chatRoomId = chatroomId.key!
        print("chatroom id is \(self.chatRoomId)")
        
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm"
    
           msgField.endEditing(true)
           msgField.isEnabled = false
           sendBtn.isEnabled = false
        let db = Database.database().reference()
        let msgDict = ["sender" : self.userId!,
                          "msg" : msgField.text!,
                          "time" : formatter.string(from:Date()),
                          "reciever" : self.reciever]
        
        if everFirstChat {
            everFirstChat = false
            firstChat = false
            self.makeChatrooms()
            db.child("users")
                .child(self.uid!)
                .child(self.chatRoomId)
                .setValue([ "entry" : [self.userId! : true, self.reciever : true ]])
        }else if firstChat {
            firstChat = false
            self.makeChatrooms()
        }
        
        //메시지 전송
        db.child("chatrooms")
            .child(self.chatRoomId)
            .child("message")
            .childByAutoId()
            .setValue(msgDict){(error, ref) in
        if error != nil { print(error!) } }
        
        self.msgField.isEnabled = true
        self.sendBtn.isEnabled = true
        self.msgField.text = ""
        
    }
    
    func retrieveMsg(){
        SVProgressHUD.show()
        print("기존 대화내요d 가져온나~~~")
        
        let msgDb = Database.database().reference().child("chatrooms").child(self.chatRoomId).child("message")
        msgDb.observe(.childAdded) { (snapshot) in
            if let snapshotValue = snapshot.value as? Dictionary<String, String> {
                let text = snapshotValue["msg"]!
                let sender = snapshotValue["sender"]!
                let time = snapshotValue["time"]
                let reciever = snapshotValue["reciever"]
                
                if sender == self.userId! && reciever == self.reciever {
                     let message = ChatVO()
                     message.msg = text
                     message.sender = sender
                     message.time = time
                     message.reciever = reciever

                     self.msgArr.append(message)
                     self.configureTableView()
                     self.tableView.reloadData()
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    

    
    
    
    
   
     
    
    
    // MARK: - table view 관련 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return self.msgArr.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.msgArr[indexPath.row].sender == self.userId!{
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
    
    //셀 크기 조정
        func configureTableView(){
            tableView.estimatedRowHeight = 200.0
            tableView.rowHeight = UITableView.automaticDimension
        }
      
    
}
