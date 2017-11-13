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
    case datetime = "datetime"      //Date
}


public protocol MUDBMetaType{
    var type:MUOriginType {get}
    var notnull:Bool{get}
    var unique:Bool {get}
    var `default`:String? {get}
    var pk:Bool{get}
    var origin:Any? {get}
}
extension MUDBMetaType{
    var sqlTypeString:String{
        return "\(self.type.rawValue)\(notnull ? " not null" :"")\(unique ? " unique":"")\(`default` != nil ? " default '\(`default`!)'" :"")"
    }
}
public protocol MUContent{
    associatedtype result
    static var originType:MUOriginType {get}
    static func translateToOrigin(v:Self)->Any
    static func parseFromOrigin(origin:Any)->result
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
            if let nv = newValue{
                value = T.parseFromOrigin(origin: nv) as? T
            }else{
                value = nil
            }
        }
    }
    public var `default`: String?
    
    public var unique: Bool
    
    public var notnull: Bool
    
    public var type: MUOriginType{
        return T.originType
    }
    
    var value:T?
    public init(pk:Bool = false){
        self.pk = pk
        self.unique = false
        self.notnull = pk
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
    var keyPath:WritableKeyPath<DBType<T>,Any?>{
        return \DBType<T>.origin
    }
}

extension Int:MUContent{
    public typealias result = Int
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
    public typealias result = Int32
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
    public typealias result = Int64
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
    public typealias result = Int16
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
    public typealias result = Int8
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
    public typealias result = UInt
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
    public typealias result = UInt32
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
    public typealias result = UInt64
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
    public typealias result = UInt16
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
    public typealias result = UInt8
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
    public typealias result = String
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
    public typealias result = Double
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
    public typealias result = Float
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
    public typealias result = Data
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
    public typealias result = Date
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
extension Bool:MUContent{
    public typealias result = Bool
    public static var originType: MUOriginType {
        return .integer
    }
    
    public static func translateToOrigin(v: Bool) -> Any {
        return Int64(v ? 1 : 0)
    }
    
    public static func parseFromOrigin(origin: Any) -> Bool {
        return (origin as! Int64) > 0 ? true : false
    }
}
