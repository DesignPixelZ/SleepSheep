//
//  MUDBEntity.swift
//  text
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import Foundation

public protocol DBEntity {
    static var entityName:String {get}
    var collume:[String:MUDBMetaType] {get}
    var primary:[String:MUDBMetaType] {get}
    init()
}
extension DBEntity{
    static var entityName:String {
        return "\(self)"
    }
    var collume:[String:MUDBMetaType] {
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
    var primary:[String:MUDBMetaType] {
        return self.collume.filter({$0.value.pk}).reduce([:]) { (last, current) -> [String:MUDBMetaType] in
            var temp = last
            temp[current.0] = current.1
            return temp
        }
    }
}
