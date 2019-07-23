//
//  ArtistDetailWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

protocol ArtistDetailRouter: class {
}

typealias ArtistDetailCompletion = (() -> Void)?

class ArtistDetailWireframe {
    weak var router: MainRouter?

    private let artistDetailViewController = ArtistDetailViewController()
    private var presenter: ArtistDetailPresenter?
    private let completion: ArtistDetailCompletion

    init(completion: ArtistDetailCompletion) {
        self.completion = completion
        presenter = ArtistDetailPresenter(view: artistDetailViewController, router: self)
        artistDetailViewController.eventHandler = presenter
    }
}

extension ArtistDetailWireframe: Wireframe {

    func viewController() -> UIViewController {
        return artistDetailViewController
    }
}

extension ArtistDetailWireframe: PayloadHandler {

    func handlePayload(_ payload: Any?) {

        if let artist = payload as? Artist {
            presenter?.artist = artist
        }
    }
}

extension ArtistDetailWireframe: ArtistDetailRouter {

}