//
//  MessageVisitorView.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/9.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class MessageVisitorView: UIView {

    class func getView() -> (MessageVisitorView){
        return Bundle.main.loadNibNamed("MessageVisitorView", owner: self, options: nil)?.last as! (MessageVisitorView)
    }
}
