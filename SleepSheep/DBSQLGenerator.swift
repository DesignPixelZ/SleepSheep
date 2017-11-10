//
//  DBSQLGenerator.swift
//  text
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import Foundation

class DBSQLGenerator {
    
    class func createTable(entity:DBEntity.Type)->String{
        let prefix = "create table if not exists \(entity.entityName)("
        let temp = entity.init()
        let pks = temp.primary.map({$0.key})
        let pkcode = pks.count > 0 ? ",primary key (" + pks.joined(separator: ",") + ")" : ""
        return prefix + temp.collume.map { (c) -> String in
            return c.key + " " + c.value.sqlTypeString
        }.joined(separator: ",") + pkcode + ")"
    }
    class func deleteTable(entity:DBEntity.Type)->String{
        return "drop table \(entity.entityName)"
    }
    class func alterTableName(from:String,to:String)->String{
        return "alter table \(from) rename to \(to)"
    }
    class func addCollume(entity:DBEntity.Type ,name:String,new:MUOriginType)->String{
        let a = entity.init()
        if (a.collume.contains(where: {$0.key == name})){
            print("列已存在")
            return ""
        }
        return "alter table \(entity.entityName) add column \(name) \(new.rawValue)"
    }
    class func copyTable(from:String,to:DBEntity.Type)->String{
        let temp = to.init()
        let colume = temp.collume.map({$0.key}).joined(separator: ",")
        return "insert into \(to.entityName) select \(colume) from \(from)"
    }
    class func update(entity:DBEntity.Type)
}
