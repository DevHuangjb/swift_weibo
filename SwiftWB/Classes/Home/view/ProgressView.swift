//
//  ProgressView.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/3/1.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    /// 记录当前进度, 0.0~1.0
    var progress: CGFloat = 0.0
        {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // 画圆
        /*
         圆心: {宽度 * 0.5, 高度 * 0.5}
         半径: min(宽度, 高度)
         开始位置: 默认位置
         结束位置: 2 * PI
         */
        // 0.判断是否需要继续绘制
        if  progress >= 1.0
        {
            return
        }
        
        // 1.准备数据
        let height = rect.height * 0.5
        let width = rect.width * 0.5
        let center = CGPoint(x: width, y: height)
        let radius = min(height, width)
        let start:CGFloat = -CGFloat(M_PI_2)
        let end = 2 * CGFloat(M_PI) * progress + start
        
        // 2.设置数据
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        path.addLine(to: center)
        path.close()
        
        UIColor(white: 0.9, alpha: 0.5).setFill()
        
        // 3.绘制图形
        path.fill()
    }

}
