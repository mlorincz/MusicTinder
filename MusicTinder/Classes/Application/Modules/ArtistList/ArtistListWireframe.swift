//
//  ArtistListWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

protocol ArtistListRouter : class {
    func pushDiscoverScreen()
    func pushArtistDetailScreen(_ artist: Artist)
}

typealias ArtistListCompletion = (() -> ())?

class ArtistListWireframe {
    weak var router : MainRouter?

    fileprivate let artistListViewController = ArtistListViewController()
    fileprivate var presenter: ArtistListPresenter?
    fileprivate let completion: ArtistListCompletion

    init(completion: ArtistListCompletion) {
        self.completion = completion
        presenter = ArtistListPresenter(view: artistListViewController, router: self)
        artistListViewController.eventHandler = presenter
    }
}

extension ArtistListWireframe : Wireframe {
    
    func viewController() -> UIViewController {
        return artistListViewController
    }
}

extension ArtistListWireframe : ArtistListRouter {

    func pushDiscoverScreen() {
        UIViewController.setBackButton("", target: self.viewController())
        router?.pushScreen(.Discover, withNavigationController: self.viewController().navigationController!)
    }
    
    func pushArtistDetailScreen(_ artist: Artist) {
        UIViewController.setBackButton("", target: self.viewController())
        router?.pushScreen(.ArtistDetail, withNavigationController: self.viewController().navigationController!, payload: artist)
    }
}
