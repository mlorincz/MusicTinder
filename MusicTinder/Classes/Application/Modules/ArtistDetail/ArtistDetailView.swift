//
//  ArtistDetailView.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol ArtistDetailView : class {
    func updateArtist(_ artist: Artist)
    func updateSong(_ song: Song)
    func updateArtistInfo(_ info: String)
    func showButteringLabel()
    func hideBufferingLabel()
    func toggleListenButton(_ isListen: Bool)
}
