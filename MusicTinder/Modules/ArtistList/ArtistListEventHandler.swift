//
//  ArtistListEventHandler.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 2019. 07. 23..
//  Copyright © 2019. MateLorincz. All rights reserved.
//

import Foundation

protocol ArtistListEventHandler: class {

    func didTapDiscoverButton()
    func viewDidLoad()
    func didDeleteArtist(_ artist: Artist)
    func didSelectArtist(_ artist: Artist)
}
