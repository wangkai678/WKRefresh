//
//  TestViewController.swift
//  WKRefresh
//
//  Created by wangkai on 2017/6/12.
//  Copyright © 2017年 wangkai. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var table : UITableView? = nil
    
    deinit {
        print("TestViewController释放了")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tab : UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .
            plain)
        tab.delegate = self
        tab.dataSource = self
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.view.addSubview(tab)
        table = tab
        table?.wk_refreshHeader { [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                self.table?.wk_endRefreshHeader();
                self.table = nil
            })
        }
    }
}

extension TestViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    

    
}

