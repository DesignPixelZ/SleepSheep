//
//  DBExtensionType.swift
//  SleepSheep
//
//  Created by hao yin on 2017/11/13.
//  Copyright © 2017年 yyk. All rights reserved.
//

import UIKit
//extension UIImage:MUContent{
//    public typealias result = UIImage
//    public static var originType: MUOriginType {
//        return .blob
//    }
//
//    public static func translateToOrigin(v: UIImage) -> Any {
//        return UIImageJPEGRepresentation(v, 0.75) as Any
//    }
//
//    public static func parseFromOrigin(origin: Any) -> UIImage {
//        let data = origin as! Data
//
//        return UIImage(data: data) ?? UIImage()
//    }
//}
public protocol MUExtContent:MUContent {
    var ext:String? {get set}
}
public class DBSmallImage:UIImage,MUContent{
    public static func parseFromOrigin(origin: Any) -> DBSmallImage {
        let data = origin as! Data
        
        return DBSmallImage(data: data) ?? DBSmallImage()
    }
    
    public static var originType: MUOriginType = .blob
    
    public static func translateToOrigin(v: DBSmallImage) -> Any {
        return UIImageJPEGRepresentation(v, 0.75) as Any
    }
    
    public typealias result = DBSmallImage
}
