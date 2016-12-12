//
//  PersistencyService.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation
import RealmSwift

class PersistencyService {
    
    var realm : Realm {
        get {
            return try! Realm()
        }
    }
    
    func resetRealm() {
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()
    }

    func persistArtist(_ artist: Artist) {
        
        if let _ = realm.objects(RealmArtist.self).filter("mbid == '\(artist.mbid)'").first {
            return
        }
        
        realm.beginWrite()
        let realmArtist = RealmArtist(artist: artist)
        realm.add(realmArtist)

        do {
            try realm.commitWrite()
        } catch let error as NSError {
            print("[ERROR] - \(error)")
        }
    }
    
    func artists() -> [Artist] {
        let realmArtists = realm.objects(RealmArtist.self)
        var artists = [Artist]()
        
        for realmArtist in realmArtists {
            let artist = realmArtist.toArtist()
            artists.append(artist)
        }
        
        return artists
    }
    
    func deleteArtist(_ artist: Artist) {
        
        if let realmArtist = realm.objects(RealmArtist.self).filter("mbid == '\(artist.mbid)'").first {
            realm.beginWrite()
            realm.delete(realmArtist)
        }
        
        do {
            try realm.commitWrite()
        } catch let error as NSError {
            print("[ERROR] - \(error)")
        }
    }
}
