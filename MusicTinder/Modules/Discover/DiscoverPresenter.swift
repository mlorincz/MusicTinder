//
//  DiscoverPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol DiscoverEventHandler: class {
    func artistSelected(_ artist: Artist)
    func didTapSearch(_ text: String)
}

class DiscoverPresenter {
    private weak var view: DiscoverView?
    private weak var router: DiscoverRouter?
    private let interactor = DiscoverInteractor()
    private var isShowingTopArtists = true

    init (view: DiscoverView, router: DiscoverRouter) {
        self.view = view
        self.router = router
        interactor.presenter = self
        LoadingView.shared.show()
        interactor.getTopArtists()
    }
}

extension DiscoverPresenter: DiscoverInteractorResult {

    func getTopArtistsFinishedWithResult(_ result: [Artist]) {
        LoadingView.shared.hide()
        isShowingTopArtists = true
        view?.updateArtists(result)
    }

    func getTopArtistsFinishedWithError(_ error: String) {
        LoadingView.shared.hide()
        print("[ERROR] - \(error)")
    }

    func artistSearchFinishedWithResult(_ result: [Artist]) {
        LoadingView.shared.hide()
        isShowingTopArtists = false
        view?.updateArtists(result)
    }

    func artistSearchFinishedWithError(_ error: String) {
        LoadingView.shared.hide()
        print("[ERROR] - \(error)")
    }
}

extension DiscoverPresenter: DiscoverEventHandler {

    func artistSelected(_ artist: Artist) {
        router?.pushTinderScreen(artist)
    }

    func didTapSearch(_ text: String) {
        view?.updateSearchText(text)

        if text.isEmpty {

            if isShowingTopArtists == false {
                LoadingView.shared.show()
                interactor.getTopArtists()
            }
        } else {
            LoadingView.shared.show()
            interactor.searchArtist(text)
        }
    }
}
