//
//  ITunesService.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 08/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol SearchITunesDelegate : class {
    func searchFinishedWithResult(_ result: Song)
    func searchFinishedWithError(_ error: String)
}

class ITunesService {
    
    fileprivate weak var searchDelegate: SearchITunesDelegate?
    fileprivate var validatedArtistName: String = ""
    fileprivate var originalArtistName: String = ""
    
    required init(searchDelegate : SearchITunesDelegate) {
        self.searchDelegate = searchDelegate
    }
    
    func search(_ artistName: String) {
        originalArtistName = artistName.lowercased()
        validatedArtistName = artistName.folding(options: .diacriticInsensitive, locale: .current).lowercased()

        guard let urlString = URLProvider.iTunesAtistURLString(validatedArtistName) else {
            self.loadSearchCachedResponse()
            return
        }
        
        guard let url = URL(string: urlString.appendResultFormat(.JSON)) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = DefaultTimeoutInterval
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            if let _ = error {
                self.loadSearchCachedResponse()
            }
            else {
                guard let data = data else {
                    self.loadSearchCachedResponse()
                    return
                }
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    self.searchDelegate?.searchFinishedWithResult(self.processSearchResult(jsonResult as AnyObject))
                }
                catch _ as NSError {
                    self.loadSearchCachedResponse()
                }
            }
        }
        
        task.resume()
    }
}

private extension ITunesService {
    
    func loadSearchCachedResponse() {
        
        if let path = Bundle.main.path(forResource: "search", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options:.allowFragments)
                searchDelegate?.searchFinishedWithResult(processSearchResult(jsonResult as AnyObject))
            }
            catch let error as NSError {
                searchDelegate?.searchFinishedWithError(error.localizedDescription)
            }
        }
        else {
            searchDelegate?.searchFinishedWithError("Invalid filename/path")
        }
    }

    func processSearchResult(_ resultData: AnyObject) -> Song {
        var result = Song(artistName: "", collectionName: "", trackName: "", primaryGenreName: "", previewUrl: .none, artworkUrl100: .none, artistViewUrl: .none)
        if let resultsArray = resultData["results"] as? [AnyObject] {
            var artistDictionary: AnyObject?
            
            for artist in resultsArray {
                if let artistName = artist["artistName"] as? String, artistName.lowercased() == validatedArtistName || artistName.lowercased() == originalArtistName {
                    artistDictionary = artist
                    break
                }
            }
            
            if let artistDictionary = artistDictionary {

                if let artistName = artistDictionary["artistName"] as? String {
                    result.artistName = artistName
                }

                if let collectionName = artistDictionary["collectionName"] as? String {
                    result.collectionName = collectionName
                }

                if let trackName = artistDictionary["trackName"] as? String {
                    result.trackName = trackName
                }

                if let primaryGenreName = artistDictionary["primaryGenreName"] as? String {
                    result.primaryGenreName = primaryGenreName
                }

                if let previewUrl = artistDictionary["previewUrl"] as? String {
                    result.previewUrl = URL(string: previewUrl)!
                }

                if let artworkUrl100 = artistDictionary["artworkUrl100"] as? String {
                    result.artworkUrl100 = URL(string: artworkUrl100)!
                }

                if let artistViewUrl = artistDictionary["artistViewUrl"] as? String {
                    result.artistViewUrl = URL(string: artistViewUrl)!
                }
            }
        }
        
        return result
    }
}
