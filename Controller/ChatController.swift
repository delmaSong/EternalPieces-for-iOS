//
//  ChatController.swift
//  EternalPieces
//
//  Created by delma on 16/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//  채팅방 컨트롤러 

import Foundation
import UIKit

class ChatController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var back: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
    }
    
    var dataSet = [
        ("안녕하세요", "12:11"),
        ("이 도안 받고싶은데요","12:12")
    ]
    
    lazy var list: [ChatVO] = {
       var datalist = [ChatVO]()
        for(msg, time) in self.dataSet{
            let cvo = ChatVO()
            cvo.msg = msg
            cvo.time = time
            
            datalist.append(cvo)
        }
        
        return datalist
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        
        cell.msg?.text = row.msg
        cell.time?.text = row.time
       
        return cell
    }
    
    
    //touch back button
    @IBAction func goBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
