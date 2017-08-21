//
//  HomeCell.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/23.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit
import SDWebImage

class RetweetHomeCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var creatTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var vipIcon: UIImageView!
    @IBOutlet weak var memberIcon: UIImageView!
    @IBOutlet weak var widthCons: NSLayoutConstraint!
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var picCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var status : Status?{
        didSet{
            userNameLabel.text = status?.user?.screen_name
            let iconUrl = URL(string: status!.user!.profile_image_url!)
            userIcon.sd_setImage(with: iconUrl)
            creatTimeLabel.text = status?.created_at
            contentLabel.text = status?.text
            
            // 2.设置认证图标
            if let type = status?.user?.verified_type
            {
                var name = ""
                switch type
                {
                case 0:
                    name = "avatar_vip"
                case 2, 3, 5:
                    name = "avatar_enterprise_vip"
                case 220:
                    name = "avatar_grassroot"
                default:
                    name = ""
                }
                vipIcon.image = UIImage(named: name)
            }
            
            // 4.设置会员图标
            if let rank = status?.user?.mbrank
            {
                if rank >= 1 && rank <= 6
                {
                    memberIcon.image = UIImage(named: "common_icon_membership_level\(rank)")
                    userNameLabel.textColor = UIColor.orange
                }else
                {
                    memberIcon.image = nil
                    userNameLabel.textColor = UIColor.black
                }
                
            }
            
            //来源
            var rest = ""
            if let sourceStr: NSString = status?.source as NSString?, sourceStr != ""
            {
                // 6.1获取从什么地方开始截取
                let startIndex = sourceStr.range(of: ">").location + 1
                // 6.2获取截取多长的长度
                let length = sourceStr.range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
                
                // 6.3截取字符串=
                rest = sourceStr.substring(with: NSRange(location: startIndex,length: length))
            }
            
            // 5.设置时间
            creatTimeLabel.text = "刚刚"
            if let timeStr = status?.created_at
            {
                let createDate = DateTool.createDate(timeStr: timeStr, formatStr: "EE MM dd HH:mm:ss Z yyyy")
                creatTimeLabel.text = DateTool.dateDescription(date: createDate) + "  " + rest
            }
            
            let (itemSize,collectionSize) = calculateSize()
            flowLayout.itemSize = itemSize
            widthCons.constant = collectionSize.width
            heightCons.constant = collectionSize.height
            picCollectionView.reloadData()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.none
        picCollectionView.delegate = self
        picCollectionView.dataSource = self
        picCollectionView.register(PicCell.classForCoder(), forCellWithReuseIdentifier: "PicCell")
    }
    
    class func getCell(tableView : UITableView) -> RetweetHomeCell {
        var cell : RetweetHomeCell? = tableView.dequeueReusableCell(withIdentifier: "RetweetHomeCell") as! RetweetHomeCell?
        guard let tempCell = cell else {
            cell = Bundle.main.loadNibNamed("RetweetHomeCell", owner: self, options: nil)?.first as? RetweetHomeCell
            return cell!
        }
        return tempCell
        
    }
    // MARK: - 外部控制方法
    func calculateRowHeight(status : Status) -> CGFloat
    {
        // 1.设置数据
        self.status = status
        
        // 2.跟新UI
        self.layoutIfNeeded()
        
        // 3.返回底部视图最大的Y
        return separatorView.frame.maxY
    }
    
    // MARK: - 内部控制方法
    /// 计算cell和collectionview的尺寸
    private func calculateSize() -> (CGSize, CGSize)
    {
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        let count = status?.thumbnail_pic?.count ?? 0
        // 没有配图
        if count == 0
        {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 一张配图
        if count == 1
        {
            let key = status?.thumbnail_pic!.first!.absoluteString
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

extension RetweetHomeCell : UICollectionViewDelegate
{
    
}
extension RetweetHomeCell : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.thumbnail_pic?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCell
        cell.picUrl = status?.thumbnail_pic?[indexPath.item]
        cell.backgroundColor = UIColor.green
        return cell
        
    }
}

