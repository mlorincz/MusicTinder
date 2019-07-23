//
//  ArtistListInteractorDelegate.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 2019. 07. 23..
//  Copyright © 2019. MateLorincz. All rights reserved.
//

import Foundation

protocol ArtistListInteractorDelegate: class {

    func fetchArtistsDidFail(with error: Error?)
    func fetchArtistsDidFinishSuccessful(with artists: [Artist])
    func deleteArtistsDidFail(with error: Error?)
    func deleteArtistsDidFinishSuccessful()
}
