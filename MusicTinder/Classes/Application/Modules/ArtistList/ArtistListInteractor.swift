//
//  ArtistListInteractor.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

class ArtistListInteractor {
    
    weak var presenter: ArtistListPresenter?
    
    fileprivate var persistencyService : PersistencyService? {
        get {
            return PersistencyService()
        }
    }
    
    func persistedArtists() -> [Artist] {
        return persistencyService?.artists() ?? []
    }
    
    func deleteArtist(_ artist: Artist) {
        persistencyService?.deleteArtist(artist)
    }
}

