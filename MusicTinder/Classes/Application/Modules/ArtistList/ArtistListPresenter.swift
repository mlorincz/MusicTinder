//
//  ArtistListPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol ArtistListEventHandler : class {
    func handleDiscoverTapped()
    func fetchPersistedArtists()
    func didDeleteArtist(_ artist: Artist)
    func artistSelected(_ artist: Artist)
}

class ArtistListPresenter {
    fileprivate weak var view: ArtistListView?
    fileprivate weak var router: ArtistListRouter?
    fileprivate let interactor = ArtistListInteractor()
    
    init (view: ArtistListView, router: ArtistListRouter) {
        self.view = view
        self.router = router
    }
}

extension ArtistListPresenter : ArtistListEventHandler {
    
    func handleDiscoverTapped() {
        router?.pushDiscoverScreen()
    }
    
    func fetchPersistedArtists() {
        self.view?.updateArtists(interactor.persistedArtists())
    }
    
    func didDeleteArtist(_ artist: Artist) {
        interactor.deleteArtist(artist)
    }
    
    func artistSelected(_ artist: Artist) {
        router?.pushArtistDetailScreen(artist)
    }
}
