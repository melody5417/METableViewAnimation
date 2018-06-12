//
//  AppDelegate.swift
//  METableViewAnimation
//
//  Created by yiqiwang(王一棋) on 2018/6/12.
//  Copyright © 2018年 yiqiwang(王一棋). All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navigationController
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
        return true
    }

}

