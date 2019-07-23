//
//  MainRouter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 2019. 07. 23..
//  Copyright © 2019. MateLorincz. All rights reserved.
//

import UIKit

protocol MainRouter: class {

    func pushScreen(_ screen: Screen, payload: Any?)
    func popWireframe(_ wireframe: Wireframe, toRoot isPopToRoot: Bool)
}

// MARK: - Protocol Extension

extension MainRouter {

    func pushScreen(_ screen: Screen, payload: Any? = .none) {
        pushScreen(screen, payload: payload)
    }

    func popWireframe(_ wireframe: Wireframe, toRoot isPopToRoot: Bool = false) {
        popWireframe(wireframe, toRoot: isPopToRoot)
    }
}
