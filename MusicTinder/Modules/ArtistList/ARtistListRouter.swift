//
//  ARtistListRouter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 2019. 07. 23..
//  Copyright © 2019. MateLorincz. All rights reserved.
//

import UIKit

class ArtistListRouter {

    private weak var mainRouter: MainRouter?
    private var presenter: ArtistListPresenter?
    private var interactor: ArtistListInteractor?
    private let view: ArtistListView

    init(withMainRouter mainRouter: MainRouter, view: ArtistListView) {
        self.view = view
        self.mainRouter = mainRouter
        interactor = ArtistListInteractor(withPersistencyService: PersistencyService())
        presenter = ArtistListPresenter(view: view, router: self, interactor: interactor)
        view.eventHandler = presenter
    }
}

// MARK: - Wireframe

extension ArtistListRouter: Wireframe {

    func viewController() -> UIViewController {
        return view
    }
}

// MARK: - ArtistListRouter

extension ArtistListRouter: ArtistListWireframe {

    func pushDiscoverScreen() {
        UIViewController.setBackButton("", target: self.viewController())
        mainRouter?.pushScreen(.discover)
    }

    func pushArtistDetailScreen(_ artist: Artist) {
        UIViewController.setBackButton("", target: self.viewController())
        mainRouter?.pushScreen(.artistDetail, payload: artist)
    }
}
