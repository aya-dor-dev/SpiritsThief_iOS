//
//  AppDelegate.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 19/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        Alamofire.SessionManager(configuration: configuration)
        
        if UserDefaults.standard.string(forKey: Constants.PREF_COUNTRY) == nil {
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnBoarding")
            self.window?.rootViewController = rootController
        }
        return true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let path = components.path else {
                return false
        }
        
        let routes = path.split(separator: "/")
        if !routes.isEmpty {
            let route = String(routes[0])
            if route == "bottle" {
                guard let bottleId = Int(routes[1]) else {
                    return false
                }
                
                if self.window?.rootViewController?.presentedViewController != nil {
                    self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                }
                let mainTabBar = self.window?.rootViewController?.storyboard?.instantiateInitialViewController() as? MainTabbarViewController
                let nc = mainTabBar!.viewControllers![0] as! UINavigationController
                let vc = nc.viewControllers[0] as! ViewController
                vc.performSegue(withIdentifier: "viewBottle", sender: bottleId)
                
                self.window?.rootViewController?.present(mainTabBar!, animated: true, completion: nil)
                AnalyticsManager.viewBottleFromSharedLink(bottleId: UInt64(bottleId))
            }
        }
        
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
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

