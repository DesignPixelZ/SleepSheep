//
//  ViewController.swift
//  SleepSheep
//
//  Created by Francis on 2017/11/10.
//  Copyright © 2017年 yyk. All rights reserved.
//

import UIKit

class p: DBEntity {

    var x = DBType<Int>(pk: true)
    var i = DBType<UIImage>()
    var pp = DBType<String>()
    override func result(info: [String : Any]) {
        self.x.origin = info["x"]
        self.i.origin = info["i"]
        self.pp.origin = info["k"]
    }
    public required init() {super.init()}
}

class ViewController: UIViewController {

    let m = MUDataBaseManager(DBName: "message")
    override func viewDidLoad() {
        super.viewDidLoad()
        try! m .createEntity(entity: p.self)
        let a = p()
        a.x.value = 90
        a.pp.value = nil
        a.i.value = #imageLiteral(resourceName: "IMG_1342")
        try! m.insertUpdate(entity: a)
        
        let q = m.select(entityClass: p.self, condition: nil, values: [])
        self.view.layer.contents = q[0].i.value?.cgImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

