//
//  ViewController.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/7.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self .dismiss(animated: true, completion: nil)
    }


}

