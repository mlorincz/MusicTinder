//
//  DiscoverPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol DiscoverEventHandler : class {
    func artistSelected(_ artist: Artist)
    func didTapSearch(_ text: String)
}

class DiscoverPresenter {
    fileprivate weak var view: DiscoverView?
    fileprivate weak var router: DiscoverRouter?
    fileprivate let interactor = DiscoverInteractor()
    fileprivate var isShowingTopArtists = true
    
    init (view: DiscoverView, router: DiscoverRouter) {
        self.view = view
        self.router = router
        interactor.presenter = self
        LoadingIndicator.presentLoadingIndicator()
        interactor.getTopArtists()
    }
}

extension DiscoverPresenter : DiscoverInteractorResult {
    
    func getTopArtistsFinishedWithResult(_ result: [Artist]) {
        LoadingIndicator.dismissLoadingIndicator()
        isShowingTopArtists = true
        view?.updateArtists(result)
    }
    
    func getTopArtistsFinishedWithError(_ error: String) {
        LoadingIndicator.dismissLoadingIndicator()
        print("[ERROR] - \(error)")
    }
    
    
    func artistSearchFinishedWithResult(_ result: [Artist]) {
        LoadingIndicator.dismissLoadingIndicator()
        isShowingTopArtists = false
        view?.updateArtists(result)
    }
    
    func artistSearchFinishedWithError(_ error: String) {
        LoadingIndicator.dismissLoadingIndicator()
        print("[ERROR] - \(error)")
    }
}

extension DiscoverPresenter : DiscoverEventHandler {
    
    func artistSelected(_ artist: Artist) {
        router?.pushTinderScreen(artist)
    }
    
    func didTapSearch(_ text: String) {
        view?.updateSearchText(text)

        if text.isEmpty {
            
            if isShowingTopArtists == false {
                LoadingIndicator.presentLoadingIndicator()
                interactor.getTopArtists()
            }
        }
        else {
            LoadingIndicator.presentLoadingIndicator()
            interactor.searchArtist(text)
        }
    }
}
