//
//  ArtistListEventHandler.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 2019. 07. 23..
//  Copyright © 2019. MateLorincz. All rights reserved.
//

import Foundation

protocol ArtistListEventHandler: class {

    func handleDiscoverTapped()
    func fetchPersistedArtists()
    func didDeleteArtist(_ artist: Artist)
    func artistSelected(_ artist: Artist)
}
