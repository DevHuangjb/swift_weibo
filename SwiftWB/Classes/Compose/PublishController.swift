//
//  PublishController.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/3/2.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class PublishController: UIViewController {
    
    var parentVC : UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = RandomColor()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
