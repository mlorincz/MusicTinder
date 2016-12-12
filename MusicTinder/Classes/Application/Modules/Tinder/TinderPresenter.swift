//
//  TinderPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 06/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit
import AVFoundation

protocol TinderEventHandler : class {
    func didTapListen()
    func didTapBackButton()
    func didTapITunesButton()
    func didSwipeArtist(_ isAdded: Bool)
    func didTapAutoPlay(_ isOn: Bool)
}

private var ItemStatusContext = "ItemStatusContext"

class TinderPresenter : NSObject {
    fileprivate weak var view: TinderView?
    fileprivate weak var router: TinderRouter?
    fileprivate let interactor = TinderInteractor()
    
    fileprivate var song: Song?
    fileprivate var player: AVPlayer?
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var similarArtists: [Artist]?
    fileprivate var isAutoPlayOn = false
    fileprivate var isObserverRemoved = false
    

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
                }
                else {
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &ItemStatusContext {

            if let playerItem = object as? AVPlayerItem {
                
                switch playerItem.status {
                case .readyToPlay:
                    view?.hideBufferingLabel()
                    print("[DEBUG] - AVPlayerItem: ready to play")
                case .unknown:
                    view?.showButteringLabel()
                    print("[DEBUG] - AVPlayerItem: loading")
                case .failed:
                    view?.hideBufferingLabel()
                    print("[DEBUG] - AVPlayerItem: error")
                }
            }
        }
        else {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension TinderPresenter : TinderEventHandler {
    
    func loadPlayer() {

        if let url = song?.previewUrl {
            
            if let playerItem = playerItem, isObserverRemoved == false {
                playerItem.removeObserver(self, forKeyPath: "status", context: &ItemStatusContext)
            }
            else if isObserverRemoved {
                return
            }
            
            playerItem = AVPlayerItem(url: url as URL)
            playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.initial, context: &ItemStatusContext)
            NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            player = AVPlayer(playerItem:playerItem!)
            player?.volume = 0.5
            player?.rate = isAutoPlayOn ? 1.0 : 0.0
            view?.toggleListenButton(isAutoPlayOn)
        }
    }
    
    func didTapListen() {
        view?.toggleListenButton(player?.rate != 1.0)
        player?.rate != 1.0 ? player?.play() : player?.pause()
    }
    
    func itemDidFinishPlaying(_ notification: Notification) {
        view?.toggleListenButton(false)
        player?.seek(to: kCMTimeZero)
    }
    
    func didTapBackButton() {
        cleanupPlayer()
        self.playerItem?.removeObserver(self, forKeyPath: "status", context: &ItemStatusContext)
        isObserverRemoved = true
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
        print("[DEBUG] - Similar artists left: \(similarArtists?.count)")
        
        if let artist = artist, isAdded {
            interactor.persistArtist(artist)
        }
        
        if player?.rate == 1.0 {
            view?.toggleListenButton(true)
        }

        cleanupPlayer()

        if let similarArtists = similarArtists, similarArtists.count > 0 {
            self.artist = similarArtists.first
            self.similarArtists?.removeFirst()
            print("[DEBUG] - Load next artist: \(self.artist?.name)")
        }
        else {
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

extension TinderPresenter : TinderInteractorResult {
    
    func fetchSongFinishedWithResult(_ result: Song) {
        song = result
        view?.updateSong(result)
        loadPlayer()
    }
    
    func fetchSongFinishedWithError(_ error: String) {
        print("[ERROR] - \(error)")
    }
}
