//
//  GlobalSession.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/28.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class GlobalSession: NSObject {
    static let shareInstance: GlobalSession = {
        return GlobalSession()
    }()
    
    var currentVC : UIViewController?
    var currentHomeVC : HomeTableViewController?
    
}
