//
//  RealmArtist.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation
import RealmSwift

class RealmArtist: Object {

    dynamic var mbid: String?
    dynamic var name: String?
    dynamic var info: String?
    dynamic var genre: String?
    dynamic var imageURL: String?

    convenience init(artist: Artist) {
        self.init()
        print("[DEBUG] - persisting artist with name: \(artist.name)")
        mbid = artist.mbid
        name = artist.name
        info = artist.info
        genre = artist.genre
        imageURL = artist.imageUrl?.absoluteString
    }

    func toArtist() -> Artist {

        return Artist(name: name ?? "",
                      mbid: mbid ?? "",
                      info: info ?? "",
                      genre: genre ?? "",
                      imageUrl: (imageURL?.isEmpty ?? true) ? .none : URL(string: imageURL!))
    }
}
