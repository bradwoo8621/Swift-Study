//
//  AppDelegate.swift
//  Instagram
//
//  Created by brad.wu on 2017/4/7.
//  Copyright © 2017年 bradwoo8621. All rights reserved.
//

import UIKit
// 引入AVOSCloud, 需要在Bridging-Header里面先引入, 参考Instagram-Bridging-Header.h文件
import AVOSCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 设置与LeanCloud应用相关
        AVOSCloud.setApplicationId("U2rcyrTSzEJNSy6VbVJaEKz0-gzGzoHsz", // app id in LeanCloud application Instagram
            clientKey: "5YiIvF1jeM5CjfsQWW4e1GBj")  // app key in LeanCloud application Instagram
        
        // 跟踪统计应用打开情况
        AVAnalytics.trackAppOpened(launchOptions: launchOptions)
		
		login()
		
		// 从LeanCloud获取一个TestObject对象, 如果没有则创建,
        // let testObject = AVObject(className: "TestObject")
		// 插入一条数据, 列foo, 值bar, 如果没有foo列, 则创建
        // testObject.setObject("bar", forKey: "foo")
        // testObject.save()
		
        return true
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

	func login() {
		// 获取存储的用户名
		let username: String? = UserDefaults.standard.string(forKey: "username")
		if username != nil {
			let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let myTabBar = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
			window?.rootViewController = myTabBar
		}
	}
}

