//
//  WKRefreshHeader.swift
//  WKRefresh
//
//  Created by wangkai on 2017/6/9.
//  Copyright © 2017年 wangkai. All rights reserved.
//

import UIKit

enum WKPullDownToRefreshStatus {
    case normal
    case pulling
    case refreshing
}

class WKRefreshHeader: UIView {
    
    var pullDownToRefreshBlock: (() -> ())?
    
    fileprivate lazy var textLabel : UILabel = { [unowned self] in
        let label = UILabel()
        label.frame = CGRect(x: self.frame.size.width/2, y: 0, width: self.frame.size.width/2, height: self.frame.size.height)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkText
        label.text = "下拉刷新"
        return label
    }()
    
    fileprivate lazy var imageView : UIImageView = { [unowned self] in
       let imageView = UIImageView()
        imageView.image = UIImage(named: "normal")
        imageView.frame = CGRect(x: self.frame.size.width/2 - 50-10, y: (self.frame.size.height - 50)/2, width: 50, height: 50)
        return imageView
    }()

    fileprivate lazy var animationImages : [UIImage] = {
       var array = [UIImage]()
        for  i in 1...3{
            let image = UIImage(named: "refreshing_0\(i)")
            array.append(image!)
        }
        return array
    }()
    
   fileprivate var scrollView : UIScrollView!
   fileprivate var refreshStatus : WKPullDownToRefreshStatus = .normal {
        didSet{
            self.refreshHeaderViewUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if  (newSuperview != nil) && (newSuperview!.isKind(of: UIScrollView.self)) {
            scrollView = newSuperview as! UIScrollView
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .initial, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != "contentOffset"{ return }
        let contentOffsetY = scrollView.contentOffset.y
        let normalPullingOffset = -(kWKRefreshHeaderHeight+scrollView.contentInset.top);
        if scrollView.isDragging {
            //手拖动
            if (refreshStatus == .pulling) && (contentOffsetY > normalPullingOffset) {
                refreshStatus = .normal
            }else if  (refreshStatus == .normal) && (contentOffsetY <= normalPullingOffset){
                refreshStatus = .pulling
            }
        }else{
            //手松开
            if refreshStatus == .pulling {
                refreshStatus = .refreshing
            }
        }
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        print("WKRefreshHeader释放了")
    }
}

//MARK: 设置UI内容
extension WKRefreshHeader {
    fileprivate func setupUI(){
        addSubview(textLabel)
        addSubview(imageView)
    }
    
    fileprivate func refreshHeaderViewUI() {
        switch refreshStatus {
        case .normal:
            imageView.stopAnimating()
            textLabel.text = "下拉刷新"
            imageView.image = UIImage(named: "normal")
            break
        case .pulling:
            textLabel.text = "释放刷新"
            imageView.image = UIImage(named: "pulling")
            break
        case .refreshing:
            textLabel.text = "正在刷新..."
            imageView.animationImages = animationImages
            imageView.animationDuration = 0.1 * Double(animationImages.count)
            imageView.startAnimating()
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top + kWKRefreshHeaderHeight, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right)
            })
            
            if let tempBlock = pullDownToRefreshBlock {
                tempBlock()
            }
            
            break
        }
    }
}

extension WKRefreshHeader {
    func headerEndRefresh() {
        if refreshStatus == .refreshing {
            refreshStatus = .normal
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top - kWKRefreshHeaderHeight, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right)
            })
        }
    }
}

