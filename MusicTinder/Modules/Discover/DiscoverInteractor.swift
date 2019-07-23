//
//  DiscoverInteractor.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol DiscoverInteractorResult: class {
    func getTopArtistsFinishedWithResult(_ result: [Artist])
    func getTopArtistsFinishedWithError(_ error: String)
    func artistSearchFinishedWithResult(_ result: [Artist])
    func artistSearchFinishedWithError(_ error: String)
}

class DiscoverInteractor {
    weak var presenter: DiscoverInteractorResult?

    private var chartService: ChartService? {
        return ChartService(getTopArtistDelegate: self)
    }

    private var artistService: ArtistService? {
        return ArtistService(searchDelegate: self)
    }

    func getTopArtists() {
        DispatchQueue.global().async { [unowned self] () -> Void in
            self.chartService?.getTopArtists()
        }
    }

    func searchArtist(_ name: String) {
        DispatchQueue.global().async { [unowned self] () -> Void in
            self.artistService?.search(name)
        }
    }
}

extension DiscoverInteractor: GetTopArtistDelegate {

    func getTopArtistsFinishedWithResult(_ result: [Artist]) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.presenter?.getTopArtistsFinishedWithResult(result)
        })
    }

    func getTopArtistsFinishedWithError(_ error: String) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.presenter?.getTopArtistsFinishedWithError(error)
        })
    }
}

extension DiscoverInteractor: SearchDelegate {

    func searchFinishedWithResult(_ result: [Artist]) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.presenter?.artistSearchFinishedWithResult(result)
        })
    }

    func searchFinishedWithError(_ error: String) {
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.presenter?.artistSearchFinishedWithError(error)
        })
    }
}
