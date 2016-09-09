//
//  searchModel.swift
//  MJDemo
//
//  Created by 陈旭 on 16/9/6.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
import FMDB
class SearchDB: NSObject {
    var db: FMDatabase!
    
    static let shareInstance = SearchDB()
    
    override init() {
        super.init()
        
        guard let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last else {
            return
        }
        
        let filePath = (path as NSString).stringByAppendingPathComponent("demo.sqlite")
        
        db = FMDatabase(path: filePath)
        
        if db.open() == false {
            return
        }
        
        let sql = "CREATE TABLE IF NOT EXISTS t_searchModel (searchStr text);"
        
        db.executeUpdate(sql, withArgumentsInArray: nil)
    }
}
