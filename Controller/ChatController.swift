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
    
    override func viewDidLoad() {
        recieverTitle.text = reciever
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        //테이블뷰쪽 누르면 텍스트 쓰는거 그만
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
        configureTableView()
        retrieveMessages()
    }
    
//    var dataSet = [
//        ("안녕하세요", "12:11"),
//        ("이 도안 받고싶은데요","12:12")
//    ]
//
//    lazy var list: [ChatVO] = {
//       var datalist = [ChatVO]()
//        for(msg, time) in self.dataSet{
//            let cvo = ChatVO()
//            cvo.msg = msg
//            cvo.time = time
//
//            datalist.append(cvo)
//        }
//
//        return datalist
//    }()
    
    
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
        
       
        
      
        
       
        return UITableViewCell()
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
        
        let msgDB = Database.database().reference().child("message")
        let msgDict = ["sender" : Auth.auth().currentUser?.email,
                       "msg" : msgField.text!,
                       "time" : formatter.string(from:Date()),
                       "reciever" : self.reciever]
        
        msgDB.childByAutoId().setValue(msgDict){
            (error, reference) in
            if error != nil{
                print(error!)
            }else{
                self.msgField.isEnabled = true
                self.sendBtn.isEnabled = true
                self.msgField.text = ""
            }
        }
        
        
    }
    
    //셀 크기 조정
    func configureTableView(){
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func retrieveMessages(){
        SVProgressHUD.show()
        let msgDB = Database.database().reference().child("message")
        msgDB.observe(.childAdded){
            (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["msg"]!
            let sender = snapshotValue["sender"]!
            let time = snapshotValue["time"]
            let reciever = snapshotValue["reciever"]
            
//            if sender == Auth.auth().currentUser?.email && reciever == self.reciever {
                let message = ChatVO()
                message.msg = text
                message.sender = sender
                message.time = time
                
                self.msgArr.append(message)
                self.configureTableView()
                self.tableView.reloadData()
//            }
            SVProgressHUD.dismiss()
        }
    }
    
//    func getDestinationInfo(){
//        Database.database().reference().child("message").child("reciever").observe(DataEventType.value) { (snapshot) in
//            <#code#>
//        }
//    }
}
