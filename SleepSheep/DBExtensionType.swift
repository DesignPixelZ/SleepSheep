//
//  DBExtensionType.swift
//  SleepSheep
//
//  Created by hao yin on 2017/11/13.
//  Copyright © 2017年 yyk. All rights reserved.
//

import UIKit
extension UIImage:MUContent{
    public typealias result = UIImage
    public static var originType: MUOriginType {
        return .blob
    }

    public func translateToOrigin() -> Any {
        return UIImageJPEGRepresentation(self, 0.75) as Any
    }

    public static func parseFromOrigin(origin: Any) -> UIImage {
        let data = origin as! Data
        
        return UIImage(data: data) ?? UIImage()
    }
}



