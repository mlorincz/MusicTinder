//
//  MainWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class MainWireframe {

    private var mainNavigationController = UINavigationController()
    private var wireframes = [Wireframe]()

    init() {
        pushScreen(.artistList)
    }
}

// MARK: - Wireframe

extension MainWireframe: Wireframe {

    func viewController() -> UIViewController {
        return mainNavigationController
    }
}

// MARK: - MainRouter

extension MainWireframe: MainRouter {

    func pushScreen(_ screen: Screen, payload: Any?) {
        let wireframe = wireframeForScreen(screen)
        wireframes.append(wireframe)
        mainNavigationController.pushViewController(wireframe.viewController(), animated: true)
        handlePayload(wireframe, payload: payload)
    }

    func popWireframe(_ wireframe: Wireframe, toRoot isPopToRoot: Bool) {

        if isPopToRoot {
            mainNavigationController.popToRootViewController(animated: true)
            guard let wireframe = wireframes.first else { return }
            wireframes = [wireframe]
        } else {
            mainNavigationController.popViewController(animated: true)
            wireframes.removeLast()
        }
    }
}

// MARK: - Private Extension

private extension MainWireframe {

    func wireframeForScreen(_ screen: Screen) -> Wireframe {

        switch screen {
        case .artistList:
            return ArtistListRouter(withMainRouter: self, view: ArtistListViewController())
        case .discover:
            let wireframe = DiscoverWireframe(completion: .none)
            wireframe.router = self
            return wireframe
        case .tinder:
            let wireframe = TinderWireframe(completion: .none)
            wireframe.router = self
            return wireframe
        case .artistDetail:
            let wireframe = ArtistDetailWireframe(completion: .none)
            wireframe.router = self
            return wireframe
        }
    }

    func handlePayload(_ wireframe: Wireframe, payload: Any?) {

        if let payload = payload, let payloadHandler = wireframe as? PayloadHandler {
            payloadHandler.handlePayload(payload)
        }
    }
}
