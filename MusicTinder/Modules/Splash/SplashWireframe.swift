//
//  SplashWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

protocol SplashRouter: class {
    func displayLandingScreen()
}

typealias SplashCompletion = () -> Void

class SplashWireframe {
    private let splashViewController = SplashViewController()
    private var presenter: SplashPresenter?
    private let completion: SplashCompletion

    init(completion: @escaping SplashCompletion) {
        self.completion = completion
        presenter = SplashPresenter(view: splashViewController, router: self)
        splashViewController.eventHandler = presenter
    }
}

extension SplashWireframe: Wireframe {

    func viewController() -> UIViewController {
        return splashViewController
    }
}

extension SplashWireframe: SplashRouter {

    func displayLandingScreen() {
        completion()
    }
}
