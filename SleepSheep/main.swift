//
//  main.swift
//  text
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import Foundation





class textRN: DBEntity {
    required init() {
        
    }
    var db = DBType<Int>(pk: true)
    var dnn = DBType<String>(pk:true)
    var vv = DBType<Double>()
    var k = DBType<String>()
}

let a = textRN()
print(a.collume,a.primary)

print(DBSQLGenerator.copyTable(from: "a", to: textRN.self))
