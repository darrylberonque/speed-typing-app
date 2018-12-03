//
//  AppDelegate.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/21/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        let rootVC = UserDefaults.standard.object(forKey: Constants.cachedID) == nil ? LoginViewController() : HomeViewController()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        configureKeyboardManager()

        return true
    }

    private func configureKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

