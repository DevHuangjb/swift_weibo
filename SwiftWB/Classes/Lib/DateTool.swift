//
//  DateTool.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/23.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class DateTool: NSObject {

    class func createDate(timeStr : String, formatStr : String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        // 如果不指定以下代码, 在真机中可能无法转换
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        return formatter.date(from: timeStr)!
    }
    
    class func dateDescription(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        // 创建一个日历类
        let calendar = Calendar.current
        /*
         // 该方法可以获取指定时间的组成成分 |
         let comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: createDate)
         NJLog(comps.year)
         NJLog(comps.month)
         NJLog(comps.day)
         */
        
        var formatterStr = "HH:mm"
        if calendar.isDateInToday(date)
        {
            // 今天
            // 3.比较两个时间之间的差值
            let interval = NSDate().timeIntervalSince(date)
            
            if interval < 60
            {
                return "刚刚"
            }else if interval < 60 * 60
            {
                return "\(Int(interval) / 60)分钟前"
            }else if interval < 60 * 60 * 24
            {
                return "\(Int(interval) / (60 * 60))小时前"
            }
        }else if calendar.isDateInYesterday(date)
        {
            // 昨天
            formatterStr = "昨天 " + formatterStr
        }else
        {
            // 该方法可以获取两个时间之间的差值
            //                    let comps  = calendar.components(NSCalendar.Unit.Year, fromDate: createDate, toDate: NSDate(), options: NSCalendar.Options.matchFirst)
            let unitSet = NSSet(objects: Calendar.Component.year)
            let comps = calendar.dateComponents(unitSet as! Set<Calendar.Component>, from: date, to: NSDate() as Date)
            if comps.year! >= 1
            {
                // 更早时间
                formatterStr = "yyyy-MM-dd " + formatterStr
            }else
            {
                // 一年以内
                formatterStr = "MM-dd " + formatterStr
            }
        }
        formatter.dateFormat = formatterStr
        return formatter.string(from: date)
    }
    
}
