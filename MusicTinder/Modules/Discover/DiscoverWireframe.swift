//
//  DiscoverWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

protocol DiscoverRouter: class {
    func pushTinderScreen(_ artist: Artist)
}

typealias DiscoverCompletion = (() -> Void)?

class DiscoverWireframe {
    weak var router: MainRouter?

    private let discoverViewController = DiscoverViewController()
    private var presenter: DiscoverPresenter?
    private let completion: DiscoverCompletion

    init(completion: DiscoverCompletion) {
        self.completion = completion
        presenter = DiscoverPresenter(view: discoverViewController, router: self)
        discoverViewController.eventHandler = presenter
    }
}

extension DiscoverWireframe: Wireframe {

    func viewController() -> UIViewController {
        return discoverViewController
    }
}

extension DiscoverWireframe: DiscoverRouter {

    func pushTinderScreen(_ artist: Artist) {
        UIViewController.setBackButton("", target: self.viewController())
        router?.pushScreen(.tinder, payload: artist)
    }
}
