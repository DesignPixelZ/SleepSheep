//
//  DBSQLGenerator.swift
//  text
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import Foundation

class DBSQLGenerator {
    
    /// 生成创建表的sql
    ///
    /// - Parameter entity: 表实体类类型
    /// - Returns: sql
    class func createTable(entity:DBEntity.Type)->String{
        let prefix = "create table if not exists \(entity.entityName)("
        let temp = entity.init()
        let pks = temp.primary.map({$0.key})
        let pkcode = pks.count > 0 ? ",primary key (" + pks.joined(separator: ",") + ")" : ""
        return prefix + temp.collume.map { (c) -> String in
            return c.key + " " + c.value.sqlTypeString
        }.joined(separator: ",") + pkcode + ")"
    }
    /// 删除表sql
    ///
    /// - Parameter name: 表名
    /// - Returns: sql
    class func deleteTable(name:String)->String{
        return "drop table \(name)"
    }
    /// 修改表名
    ///
    /// - Parameters:
    ///   - from: 原表名
    ///   - to: 目标表名
    /// - Returns: sql
    class func alterTableName(from:String,to:String)->String{
        return "alter table \(from) rename to \(to)"
    }
    /// 表添加列
    ///
    /// - Parameters:
    ///   - entity: 实体类类型
    ///   - name: 列名
    ///   - new: 列原始类型
    /// - Returns: sql
    class func addCollume(entity:DBEntity.Type ,name:String,new:MUOriginType)->String{
        let a = entity.init()
        if (a.collume.contains(where: {$0.key == name})){
            print("列已存在")
            return ""
        }
        return "alter table \(entity.entityName) add column \(name) \(new.rawValue)"
    }
    /// 复制表数据
    ///
    /// - Parameters:
    ///   - from: 源表名
    ///   - to: 目标实体类类型
    /// - Returns: sql
    class func copyTable(from:String,to:DBEntity.Type)->String{
        let temp = to.init()
        let colume = temp.collume.map({$0.key}).joined(separator: ",")
        return "insert into \(to.entityName) select \(colume) from \(from)"
    }
    /// 更新行
    ///
    /// - Parameter entity: 实体
    /// - Returns: sql和参数
    class func update<T:DBEntity>(entity:T)->(String,[MUDBMetaType]){
        let key = entity.collume.filter { (v) -> Bool in
            return v.value.origin != nil
        }
        let whereKey = locateCondition(entity: entity)
        let array = key.map({$0.value})
        let sql = "update \(T.entityName) set \(key.map({$0.key + " = ?"}).joined(separator: ",")) where \(whereKey.0)"
        return (sql, array + whereKey.1)
    }
    /// 插入行
    ///
    /// - Parameter entity: 实体
    /// - Returns: sql 参数
    class func insert<T:DBEntity>(entity:T)->(String,[MUDBMetaType]){
        
        let key = entity.collume.filter { (v) -> Bool in
            return v.value.origin != nil
            }
        let sql = "insert into \(T.entityName)(\(key.map({$0.key}).joined(separator: ",") )) values(\(key.map({_ in "?"}).joined(separator: ",")))"
        let array = key.map({$0.value})
        return (sql,array)
    }
    /// 删除行
    ///
    /// - Parameter entity: 实体
    /// - Returns: sql 参数
    class func delete<T:DBEntity>(entity:T)->(String,[MUDBMetaType]){
        let condition = locateCondition(entity: entity)
        let sql = delete(entity: T.self, condition: condition.0)
        return (sql,condition.1)
    }
    /// 删除行
    ///
    /// - Parameters:
    ///   - entity: 实体类类型
    ///   - condition: 满足的条件
    /// - Returns: sql
    class func delete<T:DBEntity>(entity:T.Type,condition:String)->String{
        let sql = "delete from \(T.entityName) where \(condition)"
        return sql
    }
    /// 查询
    ///
    /// - Parameters:
    ///   - entity: 实体类类型
    ///   - condition: 条件
    ///   - limit: 分页的行
    ///   - offset: 偏移
    ///   - orderby: 列排序
    ///   - desc: 是否倒序
    /// - Returns: sql
    class func queryData<T:DBEntity>(entity:T.Type,
                                     condition:String?,
                                     limit:Int?,
                                     offset:Int?,
                                     orderby:String?,
                                     desc:Bool)->String{
    
        let sql = "select * from \(entity.entityName)"
        let conditionCode = condition != nil ? " where \(condition!)" : ""
        
        let limitCode = limit != nil ? " limit \(limit!)" : ""
        
        let offsetCode = offset != nil ? " offset \(offset!)" : ""
        
        let orderByCode = orderby != nil ? " order By \(orderby!) \(desc ? "desc" : "")" : ""
        
        return sql + conditionCode + orderByCode + limitCode + offsetCode
    }
    /// 满足条件的实体数量
    ///
    /// - Parameters:
    ///   - entity: 实体类类型
    ///   - condition: 条件
    ///   - limit: 分页行数
    ///   - offset: 偏移
    /// - Returns: sql
    class func count<T:DBEntity>(entity:T.Type,
                                 condition:String?,
                                 limit:Int?,
                                 offset:Int?)->String{
        let sql = "select count(*) from \(entity.entityName)"
        let conditionCode = condition != nil ? " where \(condition!)" : ""
        
        let limitCode = limit != nil ? " limit \(limit!)" : ""
        
        let offsetCode = offset != nil ? " offset \(offset!)" : ""
        
        return sql + conditionCode + limitCode + offsetCode
    }
    /// 最大值
    ///
    /// - Parameters:
    ///   - collume: 列名
    ///   - entity: 实体类类型
    ///   - condition: 条件
    ///   - limit: 分页行数
    ///   - offset: 偏移
    /// - Returns: sql
    class func max<T:DBEntity>(collume:String,entity:T.Type,
                               condition:String?,
                               limit:Int?,
                               offset:Int?)->String{
        let sql = "select max(\(collume)) from \(entity.entityName)"
        let conditionCode = condition != nil ? " where \(condition!)" : ""
        
        let limitCode = limit != nil ? " limit \(limit!)" : ""
        
        let offsetCode = offset != nil ? " offset \(offset!)" : ""
        
        return sql + conditionCode + limitCode + offsetCode
    }
    /// 最小值
    ///
    /// - Parameters:
    ///   - collume: 列名
    ///   - entity: 实体类类型
    ///   - condition: 条件
    ///   - limit: 分页行数
    ///   - offset: 偏移
    /// - Returns: sql
    class func min<T:DBEntity>(collume:String,entity:T.Type,
                               condition:String?,
                               limit:Int?,
                               offset:Int?)->String{
        let sql = "select min(\(collume)) from \(entity.entityName)"
        let conditionCode = condition != nil ? " where \(condition!)" : ""
        
        let limitCode = limit != nil ? " limit \(limit!)" : ""
        
        let offsetCode = offset != nil ? " offset \(offset!)" : ""
        
        return sql + conditionCode + limitCode + offsetCode
    }
    /// 实体查询条件
    ///
    /// - Parameter entity: 实体
    /// - Returns: sql 和参数
    class func locateCondition<T:DBEntity>(entity:T)->(String,[MUDBMetaType]){
        return (entity.primary.map({$0.key + " = ?"}).joined(separator: " and "),entity.primary.map({$0.value}))
    }
}
