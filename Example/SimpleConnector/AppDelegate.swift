//
//  AppDelegate.swift
//  SimpleConnector
//
//  Created by rafaelbaraldi on 04/16/2020.
//  Copyright (c) 2020 rafaelbaraldi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let controller = SampleListTableViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

