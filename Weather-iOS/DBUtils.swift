//
//  DBUtils.swift
//  Weather-iOS
//
//  Created by Simon Yang on 8/27/15.
//  Copyright (c) 2015 Simon Yang. All rights reserved.
//

import Foundation

class DBUtils : NSObject {
    
    
    class func getAreaid(areadName:String) -> String {
    
        var areaid = ""
        var db = FMDatabase(path: NSBundle.mainBundle().pathForResource("AreaId", ofType: "db"))
        
        db.open()
        
        if let rs = db.executeQuery("SELECT areaid FROM allValues WHERE ? like '%'||name||'%' or ? like '%'||district||'%'",
            withArgumentsInArray: [areadName, areadName]) {
            if rs.next() {
                areaid = rs.stringForColumn("areaid")
                println("DBUtils.getAreaid(), areaid == \(areaid)")
            }
        } else {
            println("select failed: \(db.lastErrorMessage())")
        }
    
        db.close()
        
        return areaid
    
    }

}
