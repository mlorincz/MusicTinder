//
//  ArtistDetailPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit
import AVFoundation

protocol ArtistDetailEventHandler : class {
    func didTapBackButton()
    func didTapListen()
    func didTapITunesButton()
}

private var ItemStatusContext = "ItemStatusContext"

class ArtistDetailPresenter : NSObject {
    fileprivate weak var view: ArtistDetailView?
    fileprivate weak var router: ArtistDetailRouter?
    fileprivate let interactor = ArtistDetailInteractor()

    fileprivate var song: Song?
    fileprivate var player: AVPlayer?
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var isObserverRemoved = false

    
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
    
    func itemDidFinishPlaying(_ notification: Notification) {
        view?.toggleListenButton(false)
        player?.seek(to: kCMTimeZero)
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

extension ArtistDetailPresenter : ArtistDetailEventHandler {
    
    func didTapBackButton() {
        cleanupPlayer()
        self.playerItem?.removeObserver(self, forKeyPath: "status", context: &ItemStatusContext)
        isObserverRemoved = true
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

extension ArtistDetailPresenter : ArtistDetailInteractorResult {
    
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
        }
    }
    
    func cleanupPlayer() {
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
}
