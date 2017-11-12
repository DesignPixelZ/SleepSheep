//
//  ViewController.swift
//  SleepSheep
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import UIKit

class p: DBEntity {
    var a = DBType<String>()
    var b = DBType<Float>(pk: true)
    var t = DBType<Int>(pk:true)
    var c = DBType<Int>()
    override func result(info: [String : Any]) {
        self.a.origin = info["a"]
        self.b.origin = info["b"]
        self.c.origin = info["c"]
        self.t.origin = info["t"]
    }
    public required init() {super.init()}
}

class ViewController: UIViewController {

    let m = MUDataBaseManager(DBName: "message")
    override func viewDidLoad() {
        super.viewDidLoad()
        m.create(entityClass: p.self)
        let te = p()
        te.a.value = "sds"
        te.b.value = 1.11
        te.t.value = 10
        te.c.value = 10000
        try! m.insertUpdate(entity: te)
        print(m.select(entityClass: p.self, condition: nil, values: []))        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

