//
//  ComposeController.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/3/2.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class ComposeButton: UIButton {
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentRect.size.width, height: 60)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: contentRect.size.width, width: contentRect.size.width, height: contentRect.size.height - contentRect.size.width)
    }
}

class ComposeController: UIViewController {
    
    var isAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addAnimation()
        isAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAppear {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func addButtons() -> () {
        let btnImages = ["tabbar_compose_weibo","tabbar_compose_camera","tabbar_compose_photo","tabbar_compose_voice",
                         "tabbar_compose_friend","tabbar_compose_lbs","tabbar_compose_shooting","tabbar_compose_more"]
        let btnTitles = ["文字","拍摄","相册","音乐","好友圈","定位","直播","更多"]
        

        let btnW : CGFloat = 60
        let btnH : CGFloat = 100
        let marginX = (kScreenW - 4*btnW)/5
        let marginY : CGFloat = 50
        for i in 0..<8{
            let row = CGFloat(i / 4)
            let col = CGFloat(i % 4)
            let btn = ComposeButton()
            btn.tag = 100 + i
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.titleLabel?.textAlignment = NSTextAlignment.center
            btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            btn.setImage(UIImage(named: btnImages[i]), for: UIControlState.normal)
            btn.setTitle(btnTitles[i], for: UIControlState.normal)
            btn.setTitleColor(RGBColor(red: 51, green: 51, blue: 51, alpha: 1), for: UIControlState.normal)
            btn.frame = CGRect(x: (marginX + col*(marginX+btnW)), y:(kScreenH + row*(btnH + marginY)) , width: btnW, height: btnH)
            btn.alpha = 0
            view.addSubview(btn)
            if i == 0 {
                btn.addTarget(self, action: #selector(popPublishController), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    func addAnimation() -> () {
        for i in 0..<8{
            let row = CGFloat(i / 4)
            let col = CGFloat(i % 4)
            let duration = col * 0.04 + row * 0.02
            let btn = self.view.viewWithTag(100+i)
            UIView.animate(withDuration: 0.5, delay: TimeInterval(duration), usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                btn?.y = (btn?.y)! - kScreenH*0.5
                btn?.alpha = 1
            }, completion: { (_) in
            })
        }
    }
    
    func disAnimation() -> () {
        for i in 0..<8{
            let row = CGFloat(i / 4)
            let col = CGFloat(i % 4)
            let duration = (4-col) * 0.04 + (2-row) * 0.02
            let btn = self.view.viewWithTag(100+i)
            UIView.animate(withDuration: 0.5, delay: TimeInterval(duration), usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                btn?.y = (btn?.y)! + kScreenH*0.5
                btn?.alpha = 0
            }, completion: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        disAnimation()
    }
    
    func popPublishController() -> () {
        let vc = PublishController()
        present(vc, animated: true, completion: nil)
    }

}
