//
//  ArtistListWireframe.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol ArtistListWireframe: class {

    func pushDiscoverScreen()
    func pushArtistDetailScreen(_ artist: Artist)
}
