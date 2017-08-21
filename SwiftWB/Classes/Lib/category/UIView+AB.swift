//
//  UIView+AB.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/8.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    public var x : CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y : CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var centerX : CGFloat {
        get{
            return self.center.x
        }
        set{
            var tempCenter = self.center
            tempCenter.x = newValue
            self.center = tempCenter
        }
    }
    
    public var centerY : CGFloat {
        get{
            return self.center.y
        }
        set{
            var tempCenter = self.center
            tempCenter.y = newValue
            self.center = tempCenter
        }
    }
    
    public var width : CGFloat {
        get{
            return self.frame.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    
    public var height : CGFloat {
        get{
            return self.frame.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
}
