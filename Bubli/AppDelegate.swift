//
//  AppDelegate.swift
//  Bubli
//
//  Created by Nathan  Pahucki on 12/18/14.
//  Copyright (c) 2014 Nathan Pahucki. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Heap.setAppId("3631878694")
        #if DEBUG
        Heap.enableVisualizer()
        #endif
        return true
    }
}

