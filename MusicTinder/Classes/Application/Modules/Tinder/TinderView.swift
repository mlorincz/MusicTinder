//
//  TinderView.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 06/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol TinderView : class {

    func updateArtist(_ artist: Artist)
    func updateSong(_ song: Song)
    func showButteringLabel()
    func hideBufferingLabel()
    func toggleListenButton(_ isListen: Bool)
    func updateIsAutoPlay(_ isOn: Bool)
}
