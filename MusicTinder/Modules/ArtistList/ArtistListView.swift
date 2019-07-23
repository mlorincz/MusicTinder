//
//  ArtistListView.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

protocol ArtistListView: UIViewController {

    var eventHandler: ArtistListEventHandler? { get set }

    func updateArtists(_ artists: [Artist])
}
