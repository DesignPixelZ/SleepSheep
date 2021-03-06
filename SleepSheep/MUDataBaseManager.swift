//
//  MUDataBaseManager.swift
//  text
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import Foundation
import FMDB
open class MUDataBaseManager{
    /// 数据库对列
    var queue:FMDatabaseQueue!
    /// 数据库其他文件目录
    var other:URL!
    
    var relate:String?
    /// 创建数据库管理
    ///
    /// - Parameter DBName: 数据库名
    required public init(DBName:String,relation:String? = nil) {
        self.relate = relation
        let url = MUDataBaseManager.createDirection(dir: self.DB)
        self.other = MUDataBaseManager.createDirection(dir:MUDataBaseManager.otherDirection)
        queue = FMDatabaseQueue(path: url.path + "/\(DBName)")
        print(url)
    }
    /// 更新实体
    ///
    /// - Parameter entity: 实体
    /// - Throws: sql 执行异常
    public func update<T:DBEntity>(entity:T) throws{
        let sql = DBSQLGenerator.update(entity: entity)
        let v = sql.1.flatMap({$0.origin})
        var e:Error?
        self.queue.inDatabase { (db) in
            do {
                try db?.executeUpdate(sql.0, values: v)
            }catch{
                e = error
            }
        }
        if let error = e{
            throw error
        }
        self.queue.close()
    }
    /// 插入实体
    ///
    /// - Parameter entity: 实体
    /// - Throws: sql执行异常
    public func insert<T:DBEntity>(entity:T) throws{
        let sql = DBSQLGenerator.insert(entity: entity)
        let v = sql.1.flatMap({$0.origin})
        var e:Error?
        self.queue.inDatabase { (db) in
            do {
                try db?.executeUpdate(sql.0, values: v)
            }catch{
                e = error
            }
        }
        if let error = e{
            throw error
        }
        self.queue.close()
    }
    /// 插入跟新实体
    /// 实体存在就更新，不存在就插入
    /// - Parameter entity: 实体
    /// - Throws: sql 执行异常
    public func insertUpdate<T:DBEntity>(entity:T) throws{
        if existEntity(entity: entity){
            try update(entity: entity)
        }else{
            try insert(entity: entity)
        }
    }
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - type: 实体类型
    ///   - condition: 条件
    ///   - value: 条件值
    /// - Returns: 实体数
    public func count<T:DBEntity>(type:T.Type,condition:String?,value:[Any]?)->UInt64{
        let sql = DBSQLGenerator.count(entity: type, condition: condition, limit: nil, offset: 0)
        var c:UInt64 = 0
        self.queue.inDatabase { (db) in
            if let fm = db?.executeQuery(sql, withArgumentsIn: []){
                if fm.next(){
                    c = fm.unsignedLongLongInt(forColumn: "count(*)")
                }
                fm.close()
            }
        }
        self.queue.close()
        return c
    }
    /// 列最大值
    ///
    /// - Parameters:
    ///   - entityClass: 实体类类型
    ///   - colume: 列名
    ///   - condition: 条件
    ///   - values: 条件值
    /// - Returns: 最大值
    public func max<T:DBEntity,V:MUContent>(entityClass:T.Type,
                                            colume:String,
                                            condition:String?,
                                            values:[Any]?)->V?{
        let sql = DBSQLGenerator.max(collume: colume, entity: entityClass.self, condition: condition, limit: nil, offset: nil)
        var result:V?
        self.queue.inDatabase { (db) in
            if let fm = db?.executeQuery(sql, withArgumentsIn: values ?? []){
                if fm.next(){
                    switch V.originType{
                    case .text:
                        result = V.parseFromOrigin(origin: fm.string(forColumn: "max(\(colume))")) as? V
                    case .integer:
                        result = V.parseFromOrigin(origin: fm.longLongInt(forColumn: "max(\(colume))")) as? V
                    case .real:
                        result = V.parseFromOrigin(origin: fm.double(forColumn: "max(\(colume))")) as? V
                    case .blob:
                        result = V.parseFromOrigin(origin: fm.data(forColumn: "max(\(colume))")) as? V
                    case .datetime:
                        result = V.parseFromOrigin(origin: fm.date(forColumn: "max(\(colume))")) as? V
                    }
                }
            }
        }
        queue.close()
        return result
    }
    /// 列最小值
    ///
    /// - Parameters:
    ///   - entityClass: 实体类类型
    ///   - colume: 列名
    ///   - condition: 条件
    ///   - values: 条件值
    /// - Returns: 最小值
    public func min<T:DBEntity,V:MUContent>(entityClass:T.Type,
                                            colume:String,
                                            condition:String?,
                                            values:[Any]?)->V?{
        let sql = DBSQLGenerator.min(collume: colume, entity: entityClass.self, condition: condition, limit: nil, offset: nil)
        var result:V?
        self.queue.inDatabase { (db) in
            if let fm = db?.executeQuery(sql, withArgumentsIn: values ?? []){
                if fm.next(){
                    switch V.originType{
                    case .text:
                        result = V.parseFromOrigin(origin: fm.string(forColumn: "min(\(colume))")) as? V
                    case .integer:
                        result = V.parseFromOrigin(origin: fm.longLongInt(forColumn: "min(\(colume))")) as? V
                    case .real:
                        result = V.parseFromOrigin(origin: fm.double(forColumn: "min(\(colume))")) as? V
                    case .blob:
                        result = V.parseFromOrigin(origin: fm.data(forColumn: "min(\(colume))")) as? V
                    case .datetime:
                        result = V.parseFromOrigin(origin: fm.date(forColumn: "min(\(colume))")) as? V
                    }
                }
                fm.close()
            }
        }
        self.queue.close()
        return result
    }
    /// 删除实体
    ///
    /// - Parameters:
    ///   - entityClass: 实体类类型
    ///   - condition: 条件
    ///   - value: 值
    /// - Throws: sql 执行异常
    public func delete<T:DBEntity>(entityClass:T.Type,condition:String,value:[Any]) throws{
        let sql = DBSQLGenerator.delete(entity: T.self, condition: condition)
        var e:Error?
        self.queue.inDatabase { (db) in
            do{
                try db?.executeUpdate(sql, values: value)
            }catch{
                e = error
            }
            
        }
        if let error = e{
            throw error
        }
        self.queue.close()
    }
    /// 删除实体
    ///
    /// - Parameter entity: 实体
    /// - Throws: sql 执行异常
    public func delete<T:DBEntity>(entity:T) throws {
        let sql = DBSQLGenerator.delete(entity: entity)
        var e:Error?
        self.queue.inDatabase { (db) in
            do{
                try db?.executeUpdate(sql.0, values: sql.1.flatMap({$0.origin}))
            }catch{
                e = error
            }
            
        }
        if let error = e{
            throw error
        }
        self.queue.close()
    }
    /// 判断实体是否存在
    ///
    /// - Parameter entity: 实体
    /// - Returns: true 存在 false 不存在
    public func existEntity<T:DBEntity>(entity:T)->Bool{
        let locate = DBSQLGenerator.locateCondition(entity: entity)
        let r = self.select(entityClass: T.self, condition: locate.0, values: locate.1.flatMap({$0.origin}))
        if r.count == 0{
            return false
        }else{
            return true
        }
    }

    
    /// 查询实体
    ///
    /// - Parameters:
    ///   - entityClass: 实体类类型
    ///   - condition: 条件
    ///   - values: 条件值
    ///   - orderBy: 排序列
    ///   - desc: 收否倒序
    ///   - limit: 分页行数
    ///   - offset: 偏移
    /// - Returns: 实体数组
    public func select<T:DBEntity>(entityClass:T.Type,
                                   condition:String?,
                                   values:[Any],
                                   orderBy:String? = nil,
                                   desc:Bool = false,
                                   limit:Int? = nil,
                                   offset:Int? = nil)->[T]{
        let sql = DBSQLGenerator.queryData(entity: entityClass, condition: condition, limit: limit, offset: offset, orderby: orderBy, desc: desc)
        var result:[T] = []
        self.queue.inDatabase { (db) in
            if let fm = db?.executeQuery(sql, withArgumentsIn: values){
                while(fm.next()){
                    let current = T()
                    var dictionary:[String:Any] = [:]
                    for i in current.collume{
                        switch(i.value.type){
                        case .text:
                            dictionary[i.key] = fm.string(forColumn: i.key)
                        case .integer:
                            dictionary[i.key] = fm.longLongInt(forColumn: i.key)
                        case .real:
                            dictionary[i.key] = fm.double(forColumn: i.key)
                        case .blob:
                            dictionary[i.key] = fm.data(forColumn: i.key)
                        case .datetime:
                            dictionary[i.key] = fm.date(forColumn: i.key)
                        }
                    }
                    current.result(info: dictionary)
                    result.append(current)
                }
                fm.close()
            }
        }
        self.queue.close()
        return result
    }
    /// 创建实体类
    ///
    /// - Parameter entityClass: 实体类类型
    public func create<T:DBEntity>(entityClass:T.Type){
        let sql = DBSQLGenerator.createTable(entity: entityClass)
        self.queue.inDatabase { (db) in
            db?.executeUpdate(sql, withArgumentsIn: [])
        }
        self.queue.close()
    }
    /// 创建实体类
    ///
    /// 自动添加新列 删除列
    ///
    /// - Parameter entity: 实体类类型
    /// - Throws: sql 执行异常
    public func createEntity(entity:DBEntity.Type) throws{
        let sql = DBSQLGenerator.createTable(entity: entity)
        
        let colume = entity.init().collume
        let memorykeys = colume.map({$0.key})
        var e:Error?
        self.queue.inDatabase { (db) in
            if let database = db{
                do{
                    if database.tableExists(entity.entityName){
                        let intable = self.DBStruct(db: database, entity: entity).map({$0.name})
                        let needAdd = memorykeys.filter({!intable.contains($0)})
                        let needDelete = intable.filter({!memorykeys.contains($0)})
                        if needDelete.count != 0{
                            let alter = DBSQLGenerator.alterTableName(from: entity.entityName, to: "temp")
                            try database.executeUpdate(alter, values: []) // 实体表名 重命名为临时表
                            try database.executeUpdate(sql, values: []) // 创建实体表
                            let copy = DBSQLGenerator.copyTable(from: "temp", to: entity)
                            try database.executeUpdate(copy, values: []) // 从临时表拷贝数据
                            let deletetmp = DBSQLGenerator.deleteTable(name: "temp")
                            try database.executeUpdate(deletetmp, values: []) //删除临时表
                        }else{
                            if needAdd.count != 0{
                                for i in needAdd{
                                    let sql = DBSQLGenerator.addCollume(entity: entity, name: i, new: colume[i]!.type)
                                    try db?.executeUpdate(sql, values: [])
                                }
                            }
                        }
                        
                    }else{
                        try database.executeUpdate(sql, values: [])
                    }
                }catch{
                    e = error
                }
            }
        }
        if let error = e{
            throw error
        }
    }
    
    
    /// 获取表结构
    ///
    /// - Parameters:
    ///   - db: 数据库对象
    ///   - entity: 实体类类型
    /// - Returns: 列结构数组
    func DBStruct(db:FMDatabase,entity:DBEntity.Type)->[DBTableColumeStruct]{
        
        var keys:[DBTableColumeStruct] = []
        if let rs = db.getTableSchema(entity.entityName){
            while rs.next() {
                let cid = rs.int(forColumn: "cid")
                let name = rs.string(forColumn: "name")
                let type = rs.string(forColumn: "type")
                let notnull = rs.bool(forColumn: "notnull")
                let df = rs.string(forColumn: "dflt_value")
                let pk = rs.bool(forColumn: "pk")
                keys.append(DBTableColumeStruct(cid: cid, name: name!, type: type!, notnull: notnull, defaultValue: df, pk: pk))
            }
            rs.close()
        }
        
        return keys
    }
    /// 数据库其他资源目录
    public class var otherDirection:String{
        return "other"
    }
    /// 根目录
    class public var root:URL{
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("SleepSheep")
        return url;
    }
    /// 数据库目录
    public var DB:String {
        return "\(self.relate ?? "default")/DB"
    }
    /// 目录创建
    ///
    /// - Parameter dir: 目录名
    /// - Returns: 目录url
    class func createDirection(dir:String)->URL{
        let url = MUDataBaseManager.root.appendingPathComponent(dir)
        var flag:ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &flag){
            if !flag.boolValue{
                try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
        }else{
            try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
}
