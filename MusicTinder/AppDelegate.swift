//
//  AppDelegate.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootWireframe: Wireframe?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareUserInterFace()
        return true
    }
}

// MARK: - Private Extension

private extension AppDelegate {

    func prepareUserInterFace() {

        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        rootWireframe = SplashWireframe(completion: { () -> Void in
            self.displayLandingWireframe()
        })
    }

    func displayLandingWireframe() {
        rootWireframe = MainWireframe()
        window?.rootViewController = rootWireframe?.viewController()
        window?.makeKeyAndVisible()
    }
}
