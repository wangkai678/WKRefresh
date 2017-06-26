//
//  UIScrollView-Extension.swift
//  WKRefresh
//
//  Created by wangkai on 2017/6/9.
//  Copyright © 2017年 wangkai. All rights reserved.
//

import UIKit

 var key = "kHeaderview"

extension UIScrollView {
    
     fileprivate var wk_header : WKRefreshHeader? {
        get {
           return objc_getAssociatedObject(self, &key) as? WKRefreshHeader
        }
        
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    fileprivate func addHeaderView(){
        if wk_header == nil {
            let headerView = WKRefreshHeader(frame: CGRect(x: 0, y: -kWKRefreshHeaderHeight, width: self.frame.size.width, height: kWKRefreshHeaderHeight))
            self.addSubview(headerView)
            wk_header = headerView
        }
    }
}

extension UIScrollView {
    //开始刷新
    func wk_refreshHeader(refreshCallBack :@escaping () -> ()) {
        addHeaderView()
        wk_header?.pullDownToRefreshBlock = {
            refreshCallBack()
        }
    }
    
    //结束刷新
    func wk_endRefreshHeader(){
        wk_header?.headerEndRefresh()
    }

}
