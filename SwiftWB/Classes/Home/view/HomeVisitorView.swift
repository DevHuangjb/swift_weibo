//
//  HomeVisitorView.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/9.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class HomeVisitorView: UIView {

    @IBOutlet weak var reloateImageView: UIImageView!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var followBtn: UIButton!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        startAnimation()
        setUpBlurView()
    }
    
    class func getView() -> (HomeVisitorView){
        return Bundle.main.loadNibNamed("HomeVisitorView", owner: self, options: nil)?.last as! (HomeVisitorView)
    }
    
    func startAnimation() -> () {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.toValue = 2 * M_PI
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        reloateImageView.layer.add(animation, forKey: nil)
    }
    
    func setUpBlurView() -> () {
        let graLayer = CAGradientLayer()
        let startColor = RGBColor(red: 238,green: 238,blue: 238,alpha: 0)
        let middleColor = RGBColor(red: 238, green: 238, blue: 238, alpha: 0.8)
        let endColor = RGBColor(red: 238, green: 238, blue: 238, alpha: 1)
        graLayer.colors = [startColor.cgColor,middleColor.cgColor,endColor.cgColor]
        graLayer.startPoint = CGPoint(x: 0, y: 0)
        graLayer.endPoint = CGPoint(x: 0, y: 1)
        graLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 175)
        blurView.layer.addSublayer(graLayer)
        
        
    }
    
}
