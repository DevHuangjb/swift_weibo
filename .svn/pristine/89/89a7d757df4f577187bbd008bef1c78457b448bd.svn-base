//
//  TitleButton.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/10.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle((title ?? "") + "  ", for: state)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: UIControlState.selected)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setTitleColor(UIColor.black, for: UIControlState.normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
