//
//  AppDelegate.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/6/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Defing the tab bar down below
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let wallpapersNavigationController = storyboard.instantiateViewController(withIdentifier: "WallpapersNavigationController") as! UINavigationController
        wallpapersNavigationController.tabBarItem.title = "Wallpapers"
        wallpapersNavigationController.tabBarItem.image = UIImage(named: "WallpapersIcon")
        
        let favoritesNavigationController = storyboard.instantiateViewController(withIdentifier: "FavoritesNavigationController")
        favoritesNavigationController.tabBarItem.title = "Favorites"
        favoritesNavigationController.tabBarItem.image = UIImage(named: "FavoritesIcon")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [wallpapersNavigationController, favoritesNavigationController]
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.tintColor = ColorPalette.BrandColor
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

