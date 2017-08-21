//
//  PictureView.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/28.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit
import SDWebImage

class PictureView: UICollectionView {
    
    var browserPresentManager : BrowserPresentManager?
    
    var picLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        return layout
    }()
    
    var picArray : [URL]?{
        didSet{
        }
    }
    
    var picMiddleArray : [URL]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewLayout = self.picLayout
        self.dataSource = self
        self.delegate = self
        register(PicCell.classForCoder(), forCellWithReuseIdentifier: "PicCell")
    }

    // MARK: - 内部控制方法
    /// 计算cell和collectionview的尺寸
    func calculateSize(picArray : [URL]?) -> (CGSize, CGSize)
    {
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        let count = picArray?.count ?? 0
        // 没有配图
        if count == 0
        {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 一张配图
        if count == 1
        {
            let key = picArray?.first!.absoluteString
            // 从缓存中获取已经下载好的图片, 其中key就是图片的url
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key)
            if image != nil {
                return (image!.size, image!.size)
            }else {
                return (CGSize.zero, CGSize.zero)
            }
        }
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10
        // 四张配图
        if count == 4
        {
            let col = 2
            let row = col
            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        }
        
        // 其他张配图
        let col = 3
        let row = (count - 1) / 3 + 1
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        
    }

}

extension PictureView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browserVC = BrowserController()
        browserVC.picArray = picArray!
        browserVC.picMiddleArray = picMiddleArray!
        browserVC.index = indexPath
        browserPresentManager = BrowserPresentManager()
        browserPresentManager?.setDefaultInfo(index: indexPath, browserDelegate: self)
        browserVC.transitioningDelegate = browserPresentManager
        browserVC.modalPresentationStyle = UIModalPresentationStyle.custom
        GlobalSession.shareInstance.currentHomeVC?.present(browserVC, animated: true, completion: nil)
    }
}

extension PictureView : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (picArray?.count ?? 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCell
        cell.milldeUrl = picMiddleArray?[indexPath.item]
        cell.picUrl = picArray?[indexPath.item]
        return cell
        
    }
}

extension PictureView: BrowserPresentManagerDelegate
{
    /// 用于创建一个和点击图片一模一样的UIImageView
    func browserPresentationWillShowImageView(browserPresenationController: BrowserPresentManager, indexPath: IndexPath) -> UIImageView {
        // 1.创建一个新的UIImageView
        let iv = UIImageView()
        // 2.设置UIImageView的图片为点击的图片
        let cell = cellForItem(at: indexPath) as! PicCell
        iv.image = cell.imageView.image
        
        iv.sizeToFit()
        // 3.返回图片
        return iv
    }
    
    /// 用于获取点击图片相对于window的frame
    func browserPresentationWillFromFrame(browserPresenationController: BrowserPresentManager, indexPath: IndexPath) -> CGRect {
        // 1.拿到被点击的cell
        let cell = cellForItem(at: indexPath) as! PicCell
        // 2.将被点击的cell的坐标系从collectionview转换到keywindow
        let frame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return frame
    }
    func browserPresentationWillToFrame(browserPresenationController: BrowserPresentManager, indexPath: IndexPath) -> CGRect {
        let width = kScreenW
        let height = kScreenH
        
        // 1.拿到被点击的cell
        let cell = cellForItem(at: indexPath) as! PicCell
        // 2.拿到被点击的图片
        let image = cell.imageView.image!
        
        // 3.计算当前图片的宽高比
        let scale = image.size.height / image.size.width
        
        // 4.利用宽高比乘以屏幕宽度, 等比缩放图片
        let imageHeight = scale * width
        
        var offsetY: CGFloat = 0
        // 5.判断当前是长图还是短图
        if imageHeight < height
        {
            // 短图
            // 4.计算顶部和底部内边距
            offsetY = (height - imageHeight) * 0.5
        }
        return CGRect(x: 0, y: offsetY, width: width, height: imageHeight)

    }
}



class PicCell: UICollectionViewCell {
    var milldeUrl : URL?{
        didSet{

        }
    }
    var picUrl : URL?{
        didSet{
            // 2.控制gif图标的显示和隐藏
            let flag = picUrl!.absoluteString.lowercased().hasSuffix("gif")
            gifView.isHidden = true
            if flag == true
            {
                gifView.isHidden = false
                imageView.sd_setImage(with: picUrl)
            }else{
                //如果不是gif，有大图缓存就用大图
                let webImageManager = SDWebImageManager.shared()
                if (webImageManager?.diskImageExists(for: milldeUrl))! {
                    imageView.image = webImageManager?.imageCache.imageFromDiskCache(forKey: milldeUrl?.absoluteString)
                }
                else{
                    imageView.sd_setImage(with: picUrl)
                }
            }
            
            
        }
    }
    lazy var imageView : UIImageView = {
        
        let temp = UIImageView()
        temp.contentMode = UIViewContentMode.scaleAspectFill
        temp.clipsToBounds = true
        return temp
    }()
    
    lazy var gifView : UIImageView = {
        let gifView = UIImageView()
        gifView.image = UIImage(named: "gif")
        gifView.contentMode = UIViewContentMode.scaleAspectFill
        return gifView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(gifView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        gifView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(17)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
