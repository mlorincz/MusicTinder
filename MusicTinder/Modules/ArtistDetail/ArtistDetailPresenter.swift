//
//  ArtistDetailPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit
import AVFoundation

protocol ArtistDetailEventHandler: class {
    func didTapBackButton()
    func didTapListen()
    func didTapITunesButton()
}

private var ItemStatusContext = "ItemStatusContext"

class ArtistDetailPresenter: NSObject {
    private weak var view: ArtistDetailView?
    private weak var router: ArtistDetailRouter?
    private let interactor = ArtistDetailInteractor()

    private var song: Song?
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerObservation: NSKeyValueObservation?

    var artist: Artist? {
        didSet {
            if let artist = artist {
                interactor.fetchSong(artist.name)
                interactor.getArtistInfo(artist.name, completion: { [unowned self] (info: String) in
                    self.view?.updateArtistInfo(info)
                })

                view?.updateArtist(artist)
            }
        }
    }

    init (view: ArtistDetailView, router: ArtistDetailRouter) {
        super.init()
        self.view = view
        self.router = router
        interactor.presenter = self
    }

    @objc func itemDidFinishPlaying(_ notification: Notification) {
        view?.toggleListenButton(false)
        player?.seek(to: CMTime.zero)
    }

    deinit {
        playerObservation = nil
    }
}

extension ArtistDetailPresenter: ArtistDetailEventHandler {

    func didTapBackButton() {
        cleanupPlayer()
    }

    func didTapListen() {
        view?.toggleListenButton(player?.rate != 1.0)
        player?.rate != 1.0 ? player?.play() : player?.pause()
    }

    func didTapITunesButton() {
        if let url = song?.artistViewUrl {
            UIApplication.shared.openURL(url as URL)
        }
    }
}

extension ArtistDetailPresenter: ArtistDetailInteractorResult {

    func fetchSongFinishedWithResult(_ result: Song) {
        song = result
        view?.updateSong(result)
        loadPlayer()
    }

    func fetchSongFinishedWithError(_ error: String) {
        print("[ERROR] - \(error)")
    }
}

private extension ArtistDetailPresenter {

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
        }
    }

    func cleanupPlayer() {
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
}
