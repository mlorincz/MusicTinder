//
//  TinderWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 06/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

protocol TinderRouter : class {

}

typealias TinderCompletion = (() -> ())?

class TinderWireframe {
    weak var router : MainRouter?
    
    fileprivate let tinderViewController = TinderViewController()
    fileprivate var presenter: TinderPresenter?
    fileprivate let completion: TinderCompletion
    
    init(completion: TinderCompletion) {
        self.completion = completion
        presenter = TinderPresenter(view: tinderViewController, router: self)
        tinderViewController.eventHandler = presenter
    }
}

extension TinderWireframe : Wireframe {
    
    func viewController() -> UIViewController {
        return tinderViewController
    }
}

extension TinderWireframe : PayloadHandler {

    func handlePayload(_ payload: Any?) {

        if let artist = payload as? Artist {
            presenter?.artist = artist
        }
    }
}

extension TinderWireframe : TinderRouter {
    
}
