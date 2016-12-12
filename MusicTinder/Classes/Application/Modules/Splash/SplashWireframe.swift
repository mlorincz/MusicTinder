//
//  SplashWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

protocol SplashRouter : class {
    func displayLandingScreen()
}

typealias SplashCompletion = () -> ()

class SplashWireframe {
    fileprivate let splashViewController = SplashViewController()
    fileprivate var presenter: SplashPresenter?
    fileprivate let completion: SplashCompletion
    
    init(completion: @escaping SplashCompletion) {
        self.completion = completion
        presenter = SplashPresenter(view: splashViewController, router: self)
        splashViewController.eventHandler = presenter
    }
}

extension SplashWireframe : Wireframe {
    
    func viewController() -> UIViewController {
        return splashViewController
    }
}

extension SplashWireframe : SplashRouter {

    func displayLandingScreen() {
        completion()
    }
}
