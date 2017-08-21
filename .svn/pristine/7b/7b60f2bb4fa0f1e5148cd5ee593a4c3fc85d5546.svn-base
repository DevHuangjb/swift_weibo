//
//  LHBoxView.swift
//  LHBoxView
//
//  Created by 李瀚 on 16/6/4.
//  Copyright © 2016年 李瀚. All rights reserved.
//

import UIKit

typealias LHBoxViewBlock = (Int) -> ()

class LHBoxView: UIView {

    fileprivate var locationView: UIView!
    fileprivate var items = [String]()
    fileprivate var itemSize: CGSize = CGSize.zero
    fileprivate var button: UIButton!
    fileprivate var isTop: Bool?
    fileprivate var traingleLayer = CAShapeLayer()
    var actionBlock: LHBoxViewBlock?
    fileprivate var layerCornerRadius: CGFloat = 2
    fileprivate var edgeOffset:CGFloat = 8
    
    var dismissBlock : (()->())? = nil
    
    
    var layerColor: UIColor = UIColor.white {
        didSet {
            traingleLayer.fillColor = layerColor.cgColor
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(locationView: UIView, isTop: Bool,items: [String]!,itemSize: CGSize!,block: LHBoxViewBlock?) {
        super.init(frame: CGRect(x: 0, y: 0, width: itemSize.width, height: CGFloat(items.count) * (itemSize.height + 1) - 1))
        self.locationView = locationView
        self.items = items!
        self.itemSize = itemSize
        self.isTop = isTop
        self.actionBlock = block
        setupView()
        addItems()
    }
    
    init(loactionView: UIView,isTop: Bool,customView: UIView!) {
        super.init(frame: customView.bounds)
        self.locationView = loactionView
        self.isTop = isTop
        customView.frame.size = customView.bounds.size
        customView.layer.cornerRadius = layerCornerRadius
        setupView()
        addSubview(customView)
    }

    
    fileprivate func setupView() {
        if locationView == nil {
            return
        }

        //三角坐标
        let triangleHeight: CGFloat = 6
        let triangleWidth: CGFloat = 10
        var pointA: CGPoint?
        var pointB: CGPoint? //小三角顶点
        var pointC: CGPoint?
        
        
        //相对屏幕的坐标
        let frames = locationView.convert(locationView.bounds, to: nil)
        
        var viewX: CGFloat = 0
        var viewY: CGFloat = 0
        let viewWidth = self.frame.size.width
        let viewHeight = self.frame.size.height
        
        let trianglepath = UIBezierPath()
        
        let pTopLeft = CGPoint(x: 0, y: 0)
        let pTopRight = CGPoint(x: viewWidth, y: 0)
        let pBottomLeft = CGPoint(x: 0, y: viewHeight)
        let pBttomRight = CGPoint(x: viewWidth, y: viewHeight)
        
        let pTopLeft_center = CGPoint(x: layerCornerRadius, y: layerCornerRadius)
        let pTopRight_center = CGPoint(x: viewWidth - layerCornerRadius, y: layerCornerRadius)
        let pBottomLeft_center = CGPoint(x: layerCornerRadius, y: viewHeight - layerCornerRadius)
        let pBottomRigeht_center = CGPoint(x: viewWidth - layerCornerRadius, y: viewHeight - layerCornerRadius)
        
        let SCREEN_WIDTH = UIScreen.main.bounds.width
        
        let midX = frames.midX
        var triangleX: CGFloat!
        if midX + viewWidth / 2 > SCREEN_WIDTH {//超出右侧屏幕
            viewX = SCREEN_WIDTH - viewWidth - edgeOffset
            triangleX = midX - viewX - triangleWidth / 2
        } else if midX - viewWidth / 2 < 0 { // 超出左侧屏幕
            viewX = edgeOffset
            triangleX = midX - edgeOffset - triangleWidth / 2
        }else {
            viewX = midX - self.frame.size.width / 2
            triangleX = viewWidth / 2 - triangleWidth / 2
        }
        
        
        if isTop == true {
            let minY = frames.minY
            
            viewY = minY - self.frame.size.height - triangleHeight
            
            pointA = CGPoint(x: triangleX, y: viewHeight)
            pointB = CGPoint(x: triangleX + triangleWidth / 2, y: viewHeight + triangleHeight)
            pointC = CGPoint(x: triangleX + triangleWidth, y: viewHeight)
 
            trianglepath.move(to: pointA!)
            trianglepath.addLine(to: pointB!)
            trianglepath.addLine(to: pointC!)
            trianglepath.addLine(to: pBttomRight)
            //以某一点为中心画弧
            //详见：http://blog.csdn.net/lgm252008/article/details/34819743
            trianglepath.addArc(withCenter: pBottomRigeht_center,
                                          radius: layerCornerRadius,
                                          startAngle: CGFloat(M_PI_2),
                                          endAngle: 0,
                                          clockwise: false)
            trianglepath.addLine(to: pTopRight)
            trianglepath.addArc(withCenter: pTopRight_center,
                                          radius: layerCornerRadius,
                                          startAngle: 0,
                                          endAngle: 1.5 * CGFloat(M_PI),
                                          clockwise: false)
            trianglepath.addLine(to: pTopLeft)
            trianglepath.addArc(withCenter: pTopLeft_center,
                                          radius: layerCornerRadius,
                                          startAngle: 1.5 * CGFloat(M_PI),
                                          endAngle: CGFloat(M_PI),
                                          clockwise: false)
            trianglepath.addLine(to: pBottomLeft)
            trianglepath.addArc(withCenter: pBottomLeft_center,
                                          radius: layerCornerRadius,
                                          startAngle: CGFloat(M_PI),
                                          endAngle: CGFloat(M_PI_2),
                                          clockwise: false)
            trianglepath.close()
    
        } else {
            let minY = frames.maxY
            viewY = minY + triangleHeight
            pointA = CGPoint(x: triangleX, y: 0)
            pointB = CGPoint(x: triangleX + triangleWidth / 2, y: -triangleHeight)
            pointC = CGPoint(x: triangleX + triangleWidth, y: 0)
            
            trianglepath.move(to: pointA!)
            trianglepath.addLine(to: pointB!)
            trianglepath.addLine(to: pointC!)
            trianglepath.addLine(to: pTopRight)
            trianglepath.addArc(withCenter: pTopRight_center,
                                          radius: layerCornerRadius,
                                          startAngle: CGFloat(M_PI)*1.5,
                                          endAngle: 0,
                                          clockwise: true)
            trianglepath.addLine(to: pBttomRight)
            trianglepath.addArc(withCenter: pBottomRigeht_center,
                                          radius: layerCornerRadius,
                                          startAngle: 0,
                                          endAngle: CGFloat(M_PI_2),
                                          clockwise: true)
            trianglepath.addLine(to: pBottomLeft)
            trianglepath.addArc(withCenter: pBottomLeft_center,
                                          radius: layerCornerRadius,
                                          startAngle: CGFloat(M_PI_2),
                                          endAngle: CGFloat(M_PI),
                                          clockwise: true)
            trianglepath.addLine(to: pTopLeft)
            trianglepath.addArc(withCenter: pTopLeft_center,
                                          radius: layerCornerRadius,
                                          startAngle: CGFloat(M_PI),
                                          endAngle: CGFloat(M_PI) * 1.5,
                                          clockwise: true)
            trianglepath.close()
        }
        
        
        self.frame = CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
        
        
        
        traingleLayer.path = trianglepath.cgPath
        traingleLayer.lineWidth = 0.5
        traingleLayer.fillColor = layerColor.cgColor
        traingleLayer.shadowColor = UIColor.gray.cgColor
        traingleLayer.shadowOffset = CGSize(width: 0, height: 0)
        traingleLayer.shadowRadius = 3
        traingleLayer.shadowOpacity = 0.5
        
        self.layer.addSublayer(traingleLayer)
        
    }
    
    fileprivate func addItems() {
        for i in 0..<items.count {
            let buttonFrame = CGRect(x: 0, y: CGFloat(i) * (itemSize.height + 1), width: self.frame.width, height: itemSize.height)
            let button = UIButton(type: .system)
            button.frame = buttonFrame
            button.setTitle(items[i], for: UIControlState())
            button.setTitleColor(UIColor.white, for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.tag = i
            button.addTarget(self, action: #selector(buttonClick(button:)), for:UIControlEvents.touchUpInside)
            addSubview(button)
            
            
            if i < items.count - 1 {
                let separatorView = UIView()
                separatorView.isUserInteractionEnabled = false
                separatorView.frame = CGRect(x: 8, y: itemSize.height*CGFloat(i+1), width: self.frame.width - 16, height: 1)
                separatorView.backgroundColor = UIColor.groupTableViewBackground
                addSubview(separatorView)
            }
        }
    }
    
    func display() {
        let keywindow = UIApplication.shared.keyWindow!
        let button = UIButton(frame: keywindow.bounds)
        button.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
        keywindow.addSubview(button)
        keywindow.addSubview(self)
        self.button = button
    }

    func dismiss() {
        self.button.removeFromSuperview()
        removeFromSuperview()
//        guard dismissBlock != nil else {
//            dismissBlock!()
//            return
//        }
        dismissBlock?()
    }
    
    @objc func buttonClick(button: UIButton) {
        if actionBlock != nil {
            let tag = button.tag
            actionBlock!(tag)
            dismiss()
        }
    }
}
