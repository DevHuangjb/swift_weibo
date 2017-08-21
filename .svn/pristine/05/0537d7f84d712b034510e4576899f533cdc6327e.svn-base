//
//  BorwserPresentManager.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/3/2.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

protocol BrowserPresentManagerDelegate: NSObjectProtocol
{
    /// 用于创建一个和点击图片一模一样的UIImageView
    func browserPresentationWillShowImageView(browserPresenationController: BrowserPresentManager, indexPath: IndexPath) -> UIImageView
    
    /// 用于获取点击图片相对于window的frame
    func browserPresentationWillFromFrame(browserPresenationController: BrowserPresentManager, indexPath: IndexPath) -> CGRect
    
    /// 用于获取点击图片最终的frame
    func browserPresentationWillToFrame(browserPresenationController: BrowserPresentManager, indexPath: IndexPath) -> CGRect
}

class BrowserPresentationController: UIPresentationController {
//    // 用于布局转场动画弹出的控件
//    override func containerViewWillLayoutSubviews()
//    {
//        // 添加蒙版
//        containerView?.addSubview(coverButton)
//        coverButton.addTarget(self, action: #selector(coverBtnClick), for: UIControlEvents.touchUpInside)
//    }
//    
//    // MARK: - 内部控制方法
//    @objc private func coverBtnClick()
//    {
//        //        NJLog(presentedViewController)
//        //        NJLog(presentingViewController)
//        // 让菜单消失
//        presentedViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    // MARK: - 懒加载
//    private lazy var coverButton: UIButton = {
//        let btn = UIButton()
//        btn.frame = kScreenBounds
//        btn.backgroundColor = UIColor.clear
//        return btn
//    }()
}

class BrowserPresentManager: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    /// 定义标记记录当前是否是展现
    private var isPresent = false
    
    /// 当前点击图片对应的索引
    private var index: IndexPath?
    
    /// 代理对象
    weak var browserDelegate: BrowserPresentManagerDelegate?
    
    /// 设置默认数据
    func setDefaultInfo(index: IndexPath, browserDelegate: BrowserPresentManagerDelegate)
    {
        self.index = index
        self.browserDelegate = browserDelegate
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BrowserPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 0.判断当前是展现还是消失
        if isPresent
        {
            // 展现
            willPresentedController(transitionContext: transitionContext)
            
        }else
        {
            // 消失
            willDismissedController(transitionContext: transitionContext)
        }
        
    }
    
    /// 执行展现动画
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning)
    {
        
        assert(index != nil, "必须设置被点击cell的indexPath")
        assert(browserDelegate != nil, "必须设置代理才能展现")
        
        // 1.获取需要弹出视图
        // 通过ToViewKey取出的就是toVC对应的view
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else
        {
            return
        }
        
        // 2.1.新建一个UIImageView, 并且上面显示的内容必须和被点击的图片一模一样
        let imageView = browserDelegate!.browserPresentationWillShowImageView(browserPresenationController: self, indexPath: index!)
        // 2.2.获取点击图片相对于window的frame, 因为容器视图是全屏的, 而图片是添加到容器视图上的, 所以必须获取相对于window的frame
        imageView.frame = browserDelegate!.browserPresentationWillFromFrame(browserPresenationController: self, indexPath: index!)
        transitionContext.containerView.addSubview(imageView)
        // 2.3.获取点击图片最终显示的尺寸
        let toFrame = browserDelegate!.browserPresentationWillToFrame(browserPresenationController: self, indexPath: index!)
        
        // 3.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            imageView.frame = toFrame
        }) { (_) -> Void in
            
            // 移除自己添加的UIImageView
            imageView.removeFromSuperview()
            
            // 显示图片浏览器
            transitionContext.containerView.addSubview(toView)
            
            // 告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }
        
        //        transitionContext.containerView()?.addSubview(toView)
        
    }
    
    /// 执行消失动画
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning)
    {
        assert(index != nil, "必须设置被点击cell的indexPath")
        assert(browserDelegate != nil, "必须设置代理才能展现")
        
        // 1.获取需要弹出视图
        // 通过ToViewKey取出的就是toVC对应的view
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else
        {
            return
        }
        fromView.removeFromSuperview()
        // 2.1.新建一个UIImageView, 并且上面显示的内容必须和被点击的图片一模一样
        let imageView = browserDelegate!.browserPresentationWillShowImageView(browserPresenationController: self, indexPath: index!)
        // 2.2.获取点击图片相对于window的frame, 因为容器视图是全屏的, 而图片是添加到容器视图上的, 所以必须获取相对于window的frame
        let fromFrame = browserDelegate!.browserPresentationWillFromFrame(browserPresenationController: self, indexPath: index!)
        
        transitionContext.containerView.addSubview(imageView)
        // 2.3.获取点击图片最终显示的尺寸
        let toFrame = browserDelegate!.browserPresentationWillToFrame(browserPresenationController: self, indexPath: index!)
        imageView.frame = toFrame
        // 3.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            imageView.frame = fromFrame
        }) { (_) -> Void in
            
            // 移除自己添加的UIImageView
            imageView.removeFromSuperview()
            
            // 告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }
    }
}
