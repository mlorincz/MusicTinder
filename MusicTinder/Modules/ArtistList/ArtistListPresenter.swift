//
//  ArtistListPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

class ArtistListPresenter {

    private weak var view: ArtistListView?
    private weak var router: ArtistListRouter?
    private weak var interactor: ArtistListInteractor?

    init (view: ArtistListView, router: ArtistListRouter, interactor: ArtistListInteractor?) {
        self.view = view
        self.router = router
        self.interactor = interactor
        interactor?.presenter = self
    }
}

// MARK: - ArtistListEventHandler

extension ArtistListPresenter: ArtistListEventHandler {

    func handleDiscoverTapped() {
        router?.pushDiscoverScreen()
    }

    func fetchPersistedArtists() {
        interactor?.fetchArtists()
    }

    func didDeleteArtist(_ artist: Artist) {
        interactor?.deleteArtist(artist)
    }

    func artistSelected(_ artist: Artist) {
        router?.pushArtistDetailScreen(artist)
    }
}

// MARK: - ArtistListInteractorDelegate

extension ArtistListPresenter: ArtistListInteractorDelegate {

    func fetchArtistsDidFail(with error: Error?) {
        print(error.debugDescription)
    }

    func fetchArtistsDidFinishSuccessful(with artists: [Artist]) {
        view?.updateArtists(artists)
    }

    func deleteArtistsDidFail(with error: Error?) {
        print(error.debugDescription)
    }

    func deleteArtistsDidFinishSuccessful() {
        print(#function)
    }
}
