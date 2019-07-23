//
//  ArtistDetailInteractor.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 13/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol ArtistDetailInteractorResult: class {
    func fetchSongFinishedWithResult(_ result: Song)
    func fetchSongFinishedWithError(_ error: String)
}

typealias GetArtistInfoCompletion = (String) -> Void

class ArtistDetailInteractor {

    weak var presenter: ArtistDetailInteractorResult?
    private var getArtistInfoCompletion: GetArtistInfoCompletion?

    private var iTunesService: ITunesService? {
        return ITunesService(searchDelegate: self)
    }

    private var artistService: ArtistService? {
        return ArtistService(getInfoDelegate: self)
    }

    func fetchSong(_ artistName: String) {
        DispatchQueue.global().async { [unowned self] () -> Void in
            self.iTunesService?.search(artistName)
        }
    }

    func getArtistInfo(_ artistName: String, completion: @escaping GetArtistInfoCompletion) {
        getArtistInfoCompletion = completion

        DispatchQueue.global().async { [unowned self] () -> Void in
            self.artistService?.getInfo(artistName)
        }
    }
}

extension ArtistDetailInteractor: SearchITunesDelegate {

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

extension ArtistDetailInteractor: GetInfoDelegate {

    func getInfoFinishedWithResult(_ result: String) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.getArtistInfoCompletion?(result)
        })
    }

    func getInfoFinishedWithError(_ error: String) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.getArtistInfoCompletion?("")
        })
    }
}
