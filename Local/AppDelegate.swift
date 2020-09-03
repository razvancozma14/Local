//
//  AppDelegate.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var assembler: Assembler = AppAssembler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let home: HomeviewControlller = assembler.resolve()
        self.window?.rootViewController = UINavigationController(rootViewController: home)
        self.window?.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            self.window?.overrideUserInterfaceStyle = .light
        }
        return true
    }



}

