//
//  MUDBEntity.swift
//  text
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import Foundation

open class DBEntity{
    public required init() {
        
    }
    /// 查询结果注入实体 (子类需要实现）
    ///
    /// - Parameter info: 查询结果字典
    public func result(info:[String:Any]){}
    
    /// 实体名
    public static var entityName:String {
        return "\(self)"
    }
    /// 实体的字典
    public var collume:[String:MUDBMetaType] {
        let mirr = Mirror(reflecting: self)
        return mirr.children.filter { (child) -> Bool in
            if (child.label != nil && child.value is MUDBMetaType){
                return true
            }
            return false
        }.map { (child) -> (String,MUDBMetaType) in
            return (child.label!,child.value as! MUDBMetaType)
            }.reduce([:]) { (last, current) -> [String:MUDBMetaType] in
                var temp = last
                temp[current.0] = current.1
                return temp
        }
        
    }
    /// 主键的字典
    public var primary:[String:MUDBMetaType] {
        return self.collume.filter({$0.value.pk}).reduce([:]) { (last, current) -> [String:MUDBMetaType] in
            var temp = last
            temp[current.0] = current.1
            return temp
        }
    }
}
/// 列结构
public struct DBTableColumeStruct {
    var cid:Int32
    var name:String
    var type:String
    var notnull:Bool
    var defaultValue:String?
    var pk:Bool
}
