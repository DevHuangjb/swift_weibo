//
//  AppDelegate.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/7.
//  Copyright © 2017 huangjinbiao. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kScreenBounds = UIScreen.main.bounds


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        MYLOG(message: NSHomeDirectory())
        changeRootController(toNewFeature: isNewVersion())
        return true
    }
    
    func changeRootController(toNewFeature: Bool) -> () {
        if toNewFeature {
            let newFeatureSB = UIStoryboard(name: "NewFeatureStoryboard", bundle: nil)
            let newFeatureVC = newFeatureSB.instantiateInitialViewController()
            window?.rootViewController = newFeatureVC
            return
        }
        window?.rootViewController = MainViewController()
    }
    
    func isNewVersion() -> Bool {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let lastVersion = UserDefaults.standard.object(forKey: "version") as? String ?? "0.0"
        if currentVersion.compare(lastVersion) == ComparisonResult.orderedDescending {
            MYLOG(message: "新版本")
            UserDefaults.standard.set(currentVersion, forKey: "version")
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

func MYLOG<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

func RGBColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

func RandomColor() -> UIColor{
    let red = Float(arc4random_uniform(256))/255.0
    let green = Float(arc4random_uniform(256))/255
    let blue = Float(arc4random_uniform(256))/255

    return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
}






