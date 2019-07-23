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

    func didTapDiscoverButton() {
        router?.pushDiscoverScreen()
    }

    func viewDidLoad() {
        interactor?.fetchArtists()
    }

    func didSelectArtist(_ artist: Artist) {
        router?.pushArtistDetailScreen(artist)
    }

    func didDeleteArtist(_ artist: Artist) {
        interactor?.deleteArtist(artist)
    }
}

// MARK: - ArtistListInteractorDelegate

extension ArtistListPresenter: ArtistListInteractorDelegate {

    func fetchArtistsDidFail(with error: Error?) {
        print(error.debugDescription)
    }

    func fetchArtistsDidFinishSuccessful(with artists: [Artist]) {

        let mockArtist = Artist(name: "Children Of Bodom", mbid: "123456789", info: "Melodic Black-Death Metal from Finland", genre: "Metal", imageUrl: .none)
        let mockArtists = [mockArtist, mockArtist, mockArtist]

        view?.updateArtists(mockArtists)
    }

    func deleteArtistsDidFail(with error: Error?) {
        print(error.debugDescription)
    }

    func deleteArtistsDidFinishSuccessful() {
        print(#function)
    }
}
