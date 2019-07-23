//
//  ArtistListInteractor.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

class ArtistListInteractor {

    weak var presenter: ArtistListInteractorDelegate?
    let persistencyService: PersistencyService

    init(withPersistencyService persistencyService: PersistencyService) {
        self.persistencyService = persistencyService
    }

    func fetchArtists() {
        presenter?.fetchArtistsDidFinishSuccessful(with: persistencyService.artists())
    }

    func deleteArtist(_ artist: Artist) {
        persistencyService.deleteArtist(artist)
        presenter?.deleteArtistsDidFinishSuccessful()
    }
}
