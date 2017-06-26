//
//  ViewController.swift
//  WKRefresh
//
//  Created by wangkai on 2017/6/9.
//  Copyright © 2017年 wangkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var table : UITableView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func enter(_ sender: UIButton) {
        self.navigationController?.pushViewController(TestViewController(), animated: true)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//          print(table!.contentInset.top)
//    }
}





