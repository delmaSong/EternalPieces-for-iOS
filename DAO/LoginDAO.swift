//
//  LoginDAO.swift
//  EternalPieces
//
//  Created by delma on 31/08/2019.
//  Copyright © 2019 다0. All rights reserved.
//

import Foundation
struct LoginVO {
    var userId = ""     //유저 아이디
    var userPw = ""     //유저 비밀번호
    var userRole = ""       //유저 역할(타티스트/타투어)
}
class LoginDAO{
    
    lazy var fmdb: FMDatabase! = {
        let fileMgr = FileManager.default
       
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("EternalDB.sqlite").path
        
        if fileMgr.fileExists(atPath: dbPath) == false{
            let dbSource = Bundle.main.path(forResource: "EternalDB", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init(){
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
  }
    
    func login(id: String!, pw: String!) -> Bool {
        let sql = """
            SELECT user_id, user_pw, user_role
            FROM User
            WHERE user_id = ?
        """
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [id!])

        if let _rs = rs{
            _rs.next()
            var record = LoginVO()

            guard _rs.string(forColumn: "user_id") != nil else {
                return false
            }
            record.userId = _rs.string(forColumn: "user_id")!
            
            guard _rs.string(forColumn: "user_pw") == pw else{
                print("입력한 비밀번호가 틀렸습니다")
                return false
            }
            record.userRole = _rs.string(forColumn: "user_role")!
            
            print("로그인 성공")
            return true
        }else{
            print("쿼리 실행 실패")
            return false
        }
    }
    
    
    
}
