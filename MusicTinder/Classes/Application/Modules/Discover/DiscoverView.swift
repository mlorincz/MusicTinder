//
//  DiscoverView.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol DiscoverView : class {
    func updateArtists(_ artists: [Artist])
    func updateSearchText(_ text: String)
}
