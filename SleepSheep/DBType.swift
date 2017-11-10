//
//  MUDBType.swift
//  text
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import Foundation

public enum MUOriginType:String{
    case text = "text"              // String
    case integer = "integer"        // Int64
    case real = "real"              //Double
    case blob = "blob"              //Data
    case datetime = "datatime"      //Date
}


public protocol MUDBMetaType{
    var type:String {get}
    var notnull:Bool{get}
    var unique:Bool {get}
    var `default`:String? {get}
    var pk:Bool{get}
    var origin:Any? {get}
}
extension MUDBMetaType{
    var sqlTypeString:String{
        return "\(type)\(notnull ? " not null" :"")\(unique ? " unique":"")\(`default` != nil ? " default '\(`default`!)'" :"")"
    }
}
public protocol MUContent{
    static var originType:MUOriginType {get}
    static func translateToOrigin(v:Self)->Any
    static func parseFromOrigin(origin:Any)->Self
}

public struct DBType<T:MUContent>:MUDBMetaType{
    public var pk: Bool

    public var origin: Any?{
        get{
            if let ov = self.value{
                return T.translateToOrigin(v: ov)
            }
            return nil
        }
        set{
            value = newValue as? T
        }
    }
    public var `default`: String?
    
    public var unique: Bool
    
    public var notnull: Bool
    
    public var type: String{
        return T.originType.rawValue
    }
    
    var value:T?
    public init(pk:Bool = false){
        self.pk = pk
        self.unique = false
        self.notnull = true
        self.default = nil
        self.value = nil
    }
    public init(unique:Bool,notnull:Bool){
        self.pk = false
        self.unique = unique
        self.notnull = notnull
        self.default = nil
        self.value = nil
    }
}

extension Int:MUContent{
    public static func parseFromOrigin(origin: Any) -> Int {
        return Int(origin as! Int64)
    }

    public static func translateToOrigin(v: Int) -> Any {
        return v
    }

    public static var originType: MUOriginType {
        return .integer
    }
}
extension Int32:MUContent{
    public static func parseFromOrigin(origin: Any) -> Int32 {
        return Int32(origin as! Int64)
    }

    public static func translateToOrigin(v: Int32) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension Int64:MUContent{
    public static func parseFromOrigin(origin: Any) -> Int64 {
        return origin as! Int64
    }

    public static func translateToOrigin(v: Int64) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension Int16:MUContent{
    public static func parseFromOrigin(origin: Any) -> Int16 {
        return Int16(origin as! Int64)
    }

    public static func translateToOrigin(v: Int16) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension Int8:MUContent{
    public static func parseFromOrigin(origin: Any) -> Int8 {
        return Int8(origin as! Int64)
    }

    public static func translateToOrigin(v: Int8) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}

extension UInt:MUContent{
    public static func parseFromOrigin(origin: Any) -> UInt {
        return UInt(origin as! Int64)
    }

    public static func translateToOrigin(v: UInt) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension UInt32:MUContent{
    public static func parseFromOrigin(origin: Any) -> UInt32 {
        return UInt32(origin as! Int64)
    }

    public static func translateToOrigin(v: UInt32) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension UInt64:MUContent{
    public static func parseFromOrigin(origin: Any) -> UInt64 {
        return UInt64(origin as! Int64)
    }

    public static func translateToOrigin(v: UInt64) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension UInt16:MUContent{
    public static func parseFromOrigin(origin: Any) -> UInt16 {
        return UInt16(origin as! Int64)
    }

    public static func translateToOrigin(v: UInt16) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension UInt8:MUContent{
    public static func parseFromOrigin(origin: Any) -> UInt8 {
        return UInt8(origin as! Int64)
    }

    public static func translateToOrigin(v: UInt8) -> Any {
        return v
    }
    
    public static var originType: MUOriginType {
        return .integer
    }
}
extension String:MUContent{
    public static func parseFromOrigin(origin: Any) -> String {
        return origin as! String
    }

    public static func translateToOrigin(v: String) -> Any {
        return v
    }

    public static var originType: MUOriginType {
        return .text
    }
}
extension Double:MUContent{
    public static func parseFromOrigin(origin: Any) -> Double {
        return origin as! Double
    }

    public static func translateToOrigin(v: Double) -> Any {
        return v
    }

    public static var originType: MUOriginType {
        return .real
    }

    
}
extension Float:MUContent{
    public static func parseFromOrigin(origin: Any) -> Float {
        return Float(origin as! Double)
    }

    public static func translateToOrigin(v: Float) -> Any {
        return v
    }

    public static var originType: MUOriginType {
        return .real
    }
}
extension Data:MUContent{
    public static func parseFromOrigin(origin: Any) -> Data {
        return origin as! Data
    }

    public static func translateToOrigin(v: Data) -> Any {
        return v
    }

    public static var originType: MUOriginType {
        return .blob
    }
}
extension Date:MUContent{
    public static func parseFromOrigin(origin: Any) -> Date {
        return origin as! Date
    }

    public static func translateToOrigin(v: Date) -> Any {
        return v
    }

    public static var originType: MUOriginType {
        return .datetime
    }
}