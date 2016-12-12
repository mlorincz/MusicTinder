//
//  MainWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

enum Screen : String {
    case ArtistList, ArtistDetail, Discover, Tinder
}

protocol MainRouter : class {
    func pushScreen(_ type: Screen, withNavigationController navigationController: UINavigationController)
    func pushScreen(_ type: Screen, withNavigationController navigationController: UINavigationController, payload: Any?)
}

class MainWireframe {
    
    fileprivate var mainViewController = UIViewController()
    fileprivate var artistListWireframe: ArtistListWireframe?
    fileprivate var artistDetailWireframe: ArtistDetailWireframe?
    fileprivate var discoverWireframe: DiscoverWireframe?
    fileprivate var tinderWireframe: TinderWireframe?
    fileprivate var centerWireframe: Wireframe?
    
    init() {
        artistListWireframe = ArtistListWireframe(completion: .none)
        artistListWireframe?.router = self
        setCenterWireframe(artistListWireframe!, embeddedInNavigation: true)
    }
    
    func setCenterWireframe(_ wireframe: Wireframe, embeddedInNavigation: Bool) {
        centerWireframe = wireframe
        mainViewController = embeddedInNavigation ? UINavigationController(rootViewController: (centerWireframe?.viewController())!) : (centerWireframe?.viewController())!
    }

    func push(_ navigationController: UINavigationController, wireFrame: Wireframe) {
        navigationController.pushViewController(wireFrame.viewController(), animated: true)
    }
}

extension MainWireframe : Wireframe {

    func viewController() -> UIViewController {
        return mainViewController
    }
}

extension MainWireframe : MainRouter {
    
    func pushScreen(_ type : Screen, withNavigationController navigationController: UINavigationController) {
        self.pushScreen(type, withNavigationController: navigationController, payload: Optional.none)
    }
    
    func pushScreen(_ type: Screen, withNavigationController navigationController: UINavigationController, payload: Any?) {
        var wireFrame: Wireframe! = Optional.none

        switch type {
        case .ArtistList:
            artistListWireframe = ArtistListWireframe(completion: .none)
            artistListWireframe?.router = self
            wireFrame = artistListWireframe
        case .Discover:
            discoverWireframe = DiscoverWireframe(completion: .none)
            discoverWireframe?.router = self
            wireFrame = discoverWireframe
        case .Tinder:
            tinderWireframe = TinderWireframe(completion: .none)
            tinderWireframe?.router = self
            wireFrame = tinderWireframe
        case .ArtistDetail:
            artistDetailWireframe = ArtistDetailWireframe(completion: .none)
            artistDetailWireframe?.router = self
            wireFrame = artistDetailWireframe
        }
        
        push(navigationController, wireFrame: wireFrame)
        
        if let payload = payload, let wireFrame = wireFrame as? PayloadHandler {
            wireFrame.handlePayload(payload)
        }
    }
}
