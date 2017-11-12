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
    public func result(info:[String:Any]){}
    public static var entityName:String {
        return "\(self)"
    }
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
    public var primary:[String:MUDBMetaType] {
        return self.collume.filter({$0.value.pk}).reduce([:]) { (last, current) -> [String:MUDBMetaType] in
            var temp = last
            temp[current.0] = current.1
            return temp
        }
    }
}
public struct DBTableColumeStruct {
    var cid:Int32
    var name:String
    var type:String
    var notnull:Bool
    var defaultValue:String?
    var pk:Bool
}
