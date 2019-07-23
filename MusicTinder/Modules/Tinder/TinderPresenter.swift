//
//  TinderPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 06/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit
import AVFoundation

protocol TinderEventHandler: class {
    func didTapListen()
    func didTapBackButton()
    func didTapITunesButton()
    func didSwipeArtist(_ isAdded: Bool)
    func didTapAutoPlay(_ isOn: Bool)
}

private var ItemStatusContext = "ItemStatusContext"

class TinderPresenter: NSObject {
    private weak var view: TinderView?
    private weak var router: TinderRouter?
    private let interactor = TinderInteractor()

    private var song: Song?
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var similarArtists: [Artist]?
    private var isAutoPlayOn = false
    private var playerObservation: NSKeyValueObservation?

    var artist: Artist? {
        didSet {
            if let artist = artist {
                view?.updateArtist(artist)
                interactor.fetchSong(artist.name)

                if let similarArtists = similarArtists {
                    if similarArtists.isEmpty {
                        interactor.getSimilarArtist(artist.name, completion: { [unowned self] (result: [Artist]) in
                            self.similarArtists = result
                        })
                    }
                } else {
                    interactor.getSimilarArtist(artist.name, completion: { [unowned self] (result: [Artist]) in
                        self.similarArtists = result
                    })
                }
            }
        }
    }

    init (view: TinderView, router: TinderRouter) {
        super.init()
        self.view = view
        self.router = router
        interactor.presenter = self
    }

    deinit {
        playerObservation = nil
    }
}

extension TinderPresenter: TinderEventHandler {

    func loadPlayer() {

        if let url = song?.previewUrl {
            playerItem = AVPlayerItem(url: url as URL)
            playerObservation = playerItem?.observe(\.status, options: NSKeyValueObservingOptions.new, changeHandler: { (playerItem: AVPlayerItem, _) in

                switch playerItem.status {
                case .readyToPlay:
                    self.view?.hideBufferingLabel()
                    print("[DEBUG] - AVPlayerItem: ready to play")
                case .unknown:
                    self.view?.showButteringLabel()
                    print("[DEBUG] - AVPlayerItem: loading")
                case .failed:
                    self.view?.hideBufferingLabel()
                    print("[DEBUG] - AVPlayerItem: error")
                default:
                    self.view?.hideBufferingLabel()
                    print("[DEBUG] - AVPlayerItem: error")
                }
            })

            NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            player = AVPlayer(playerItem: playerItem!)
            player?.volume = 0.5
            player?.rate = isAutoPlayOn ? 1.0 : 0.0
            view?.toggleListenButton(isAutoPlayOn)
        }
    }

    func didTapListen() {
        view?.toggleListenButton(player?.rate != 1.0)
        player?.rate != 1.0 ? player?.play() : player?.pause()
    }

    @objc func itemDidFinishPlaying(_ notification: Notification) {
        view?.toggleListenButton(false)
        player?.seek(to: CMTime.zero)
    }

    func didTapBackButton() {
        cleanupPlayer()
    }

    func cleanupPlayer() {
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }

    func didTapITunesButton() {
        if let url = song?.artistViewUrl {
            UIApplication.shared.openURL(url as URL)
        }
    }

    func didSwipeArtist(_ isAdded: Bool) {

        if let artist = artist, isAdded {
            interactor.persistArtist(artist)
        }

        if player?.rate == 1.0 {
            view?.toggleListenButton(true)
        }

        cleanupPlayer()

        if let similarArtists = similarArtists, !similarArtists.isEmpty {
            self.artist = similarArtists.first
            self.similarArtists?.removeFirst()
        } else {
            interactor.getSimilarArtist(artist?.name ?? "", completion: { [unowned self] (result: [Artist]) in
                self.similarArtists = result
                self.didSwipeArtist(false)
            })
        }
    }

    func didTapAutoPlay(_ isOn: Bool) {
        isAutoPlayOn = isOn
        player?.rate = isOn ? 1.0 : 0.0
        view?.updateIsAutoPlay(isOn)
    }
}

extension TinderPresenter: TinderInteractorResult {

    func fetchSongFinishedWithResult(_ result: Song) {
        song = result
        view?.updateSong(result)
        loadPlayer()
    }

    func fetchSongFinishedWithError(_ error: String) {
        print("[ERROR] - \(error)")
    }
}
