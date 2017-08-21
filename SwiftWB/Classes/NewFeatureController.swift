//
//  NewFeatureController.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/22.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit
import SnapKit

class NewFeatureController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension NewFeatureController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = collectionView.indexPathsForVisibleItems.last! as IndexPath
        let currentCell = collectionView.cellForItem(at: index) as! NewFeatureCell
        let lastCell = cell as! NewFeatureCell
        lastCell.startBtn.isHidden = true
        if index.row == 3 {
            currentCell.startAnimation()
        }
    }
}
extension NewFeatureController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newfeatureCell", for: indexPath) as! NewFeatureCell
        cell.index = indexPath.row
        return cell
    }
}

class NewFeatureCell: UICollectionViewCell {
    var animationFlag = false
    var index :Int? = 0{
        didSet{
            imageView.image = UIImage(named: "new_feature_\(index! + 1)")
            startBtn.isHidden = true
        }
    }
    
    lazy var imageView = UIImageView()
    
    lazy var startBtn : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"new_feature_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named:"new_feature_button_highlighted"), for: UIControlState.highlighted)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(startBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(imageView)
        contentView.addSubview(startBtn)
        imageView.frame = kScreenBounds
        startBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(contentView).offset(-160)
        }
    }
    
    func startBtnClick(btn:UIButton) -> () {
        UIApplication.shared.keyWindow?.rootViewController = MainViewController()
    }
    
    func startAnimation() -> () {
//        if animationFlag {
//            return
//        }
        startBtn.isHidden = false
        startBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
        startBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.startBtn.transform = CGAffineTransform.identity
        }, completion: { (_) in
//            self.animationFlag = true
            self.startBtn.isUserInteractionEnabled = true
        })
    }
}

class NewFeatureLayout: UICollectionViewFlowLayout {
    override func prepare() {
        itemSize = kScreenBounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        collectionView?.isPagingEnabled = true
        scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

