//
//  UserTools.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/20.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit

class UserTools: NSObject {
    static var kDefaults : UserDefaults?
    static var kUser : UserAccount = UserAccount()
    
    
    override class func initialize(){
        kDefaults = UserDefaults.standard
        kUser = UserAccount()
        
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(kUser.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            
            let key = NSString.init(utf8String: name!) as! String
            
            if let value = kDefaults?.object(forKey: key) {
                kUser.setValue(value, forKey: key)
            }
        }
    }
    
    class func setUser(user : UserAccount) -> () {
        kUser = user
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(kUser.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            
            let key = NSString.init(utf8String: name!) as! String
            
            if let value = kUser.value(forKey: key) {
                kDefaults?.set(value, forKey: key)
                kDefaults?.synchronize()
            }
        }
        loadUserInfo()
    }
    
    class func clearUser() -> () {
        kUser.access_token = ""
        kUser.expires_in = 0
        kUser.uid = ""
        kUser.idstr = ""
        setUser(user: kUser)
    }
    
    class func getUser() -> UserAccount {
        return kUser
    }
    
    class func getUserName() -> String {
        return kUser.name
    }
    
    class func getAccessToken() -> String{
        return kUser.access_token
    }
    
    class func isLogin() -> Bool {
        return !(kUser.idstr.startIndex == kUser.idstr.endIndex)
    }
    
    class func loadUserInfo() -> () {
        /// 获取用户信息
        
        // 1.准备请求路径
        let path = "2/users/show.json"
        // 2.准备请求参数
        let parameters = ["access_token": kUser.access_token, "uid": kUser.uid]
        // 3.发送GET请求
        NetworkTools.shareInstance.get(path, parameters: parameters, progress: nil, success: { (task, dict) in
            let userAccount = UserAccount.mj_object(withKeyValues: dict!)
            userAccount?.access_token = kUser.access_token
            UserTools.setUser(user: userAccount!)
            
        }) { (task, error) in
            MYLOG(message: error)
        }
    }
}
