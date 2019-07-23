//
//  TinderInteractor.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 06/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol TinderInteractorResult: class {
    func fetchSongFinishedWithResult(_ result: Song)
    func fetchSongFinishedWithError(_ error: String)
}

typealias GetSimilarArtistCompletion = ([Artist]) -> Void

class TinderInteractor {

    weak var presenter: TinderInteractorResult?
    private var getSimilarArtistCompletion: GetSimilarArtistCompletion?

    private var iTunesService: ITunesService? {
        return ITunesService(searchDelegate: self)
    }

    private var artistService: ArtistService? {
        return ArtistService(getSimilarDelegate: self)
    }

    private var persistencyService: PersistencyService? {
        return PersistencyService()
    }

    func persistArtist(_ artist: Artist) {
        persistencyService?.persistArtist(artist)
    }

    func persistedArtists() -> [Artist] {
        return persistencyService?.artists() ?? []
    }

    func fetchSong(_ artistName: String) {
        DispatchQueue.global().async { [unowned self] () -> Void in
            self.iTunesService?.search(artistName)
        }
    }

    func getSimilarArtist(_ artistName: String, completion: @escaping GetSimilarArtistCompletion) {
        getSimilarArtistCompletion = completion

        DispatchQueue.global().async { [unowned self] () -> Void in
            self.artistService?.getSimilar(artistName)
        }
    }
}

extension TinderInteractor: SearchITunesDelegate {

    func searchFinishedWithResult(_ result: Song) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.presenter?.fetchSongFinishedWithResult(result)
        })
    }

    func searchFinishedWithError(_ error: String) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.presenter?.fetchSongFinishedWithError(error)
        })
    }
}

extension TinderInteractor: GetSimilarDelegate {

    func getSimilarFinishedWithResult(_ result: [Artist]) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.getSimilarArtistCompletion?(result)
        })
    }

    func getSimilarFinishedWithError(_ error: String) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.getSimilarArtistCompletion?([])
        })
    }
}
