//
//  ArtistService.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol SearchDelegate : class {
    func searchFinishedWithResult(_ result: [Artist])
    func searchFinishedWithError(_ error: String)
}

protocol GetSimilarDelegate : class {
    func getSimilarFinishedWithResult(_ result: [Artist])
    func getSimilarFinishedWithError(_ error: String)
}

protocol GetInfoDelegate : class {
    func getInfoFinishedWithResult(_ result: String)
    func getInfoFinishedWithError(_ error: String)
}

class ArtistService {
    
    weak var searchDelegate: SearchDelegate?
    weak var getSimilarDelegate: GetSimilarDelegate?
    weak var getInfoDelegate: GetInfoDelegate?
    
    init(searchDelegate: SearchDelegate) {
        self.searchDelegate = searchDelegate
    }
    
    init(getSimilarDelegate: GetSimilarDelegate) {
        self.getSimilarDelegate = getSimilarDelegate
    }
    
    init(getInfoDelegate: GetInfoDelegate) {
        self.getInfoDelegate = getInfoDelegate
    }
    
    func search(_ artistName: String) {
        let validatedArtistName = artistName.folding(options: .diacriticInsensitive, locale: nil)

        guard let urlString = URLProvider.artistSearchURLString(validatedArtistName) else {
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
    
    func getSimilar(_ artistName: String) {
        let validatedArtistName = artistName.folding(options: .diacriticInsensitive, locale: nil)
        
        guard let urlString = URLProvider.similartArtistsURLString(validatedArtistName) else {
            self.loadGetSimilarCachedResponse()
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
                self.loadGetSimilarCachedResponse()
            }
            else {
                guard let data = data else {
                    self.loadGetSimilarCachedResponse()
                    return
                }
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    self.getSimilarDelegate?.getSimilarFinishedWithResult(self.processGetSimilarResult(jsonResult as AnyObject))
                }
                catch _ as NSError {
                    self.loadGetSimilarCachedResponse()
                }
            }
        } 
        
        task.resume()
    }

    func getInfo(_ artistName: String) {
        let validatedArtistName = artistName.folding(options: .diacriticInsensitive, locale: nil)
        
        guard let urlString = URLProvider.artistInfoURLString(validatedArtistName) else {
            self.loadGetInfoCachedResponse()
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
                self.loadGetInfoCachedResponse()
            }
            else {
                guard let data = data else {
                    self.loadGetInfoCachedResponse()
                    return
                }
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    self.getInfoDelegate?.getInfoFinishedWithResult(self.processGetInfoResult(jsonResult as AnyObject))
                }
                catch _ as NSError {
                    self.loadGetInfoCachedResponse()
                }
            }
        } 
        
        task.resume()
    }
}

private extension ArtistService {
    
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
    
    func loadGetSimilarCachedResponse() {
        
        if let path = Bundle.main.path(forResource: "getSimilar", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options:.allowFragments)
                getSimilarDelegate?.getSimilarFinishedWithResult(processGetSimilarResult(jsonResult as AnyObject))
            }
            catch let error as NSError {
                getSimilarDelegate?.getSimilarFinishedWithError(error.localizedDescription)
            }
        }
        else {
            getSimilarDelegate?.getSimilarFinishedWithError("Invalid filename/path")
        }
    }

    func loadGetInfoCachedResponse() {
        
        if let path = Bundle.main.path(forResource: "getInfo", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options:.allowFragments)
                getInfoDelegate?.getInfoFinishedWithResult(processGetInfoResult(jsonResult as AnyObject))
            }
            catch let error as NSError {
                getInfoDelegate?.getInfoFinishedWithError(error.localizedDescription)
            }
        }
        else {
            getInfoDelegate?.getInfoFinishedWithError("Invalid filename/path")
        }
    }

    func processSearchResult(_ resultData: AnyObject) -> [Artist] {
        var result: [Artist] = []
        
        if let resultsDictionary = resultData["results"] as? [String : AnyObject] {
            if let matchesDictionary = resultsDictionary["artistmatches"] as? [String : AnyObject] {
                if let artistArray = matchesDictionary["artist"] as? [AnyObject] {
                    
                    for artistData in artistArray {
                        
                        if let artistData = artistData as? [String : AnyObject] {
                            if let name = artistData["name"] as? String, let mbid = artistData["mbid"] as? String, let images = artistData["image"] as? [[String : String]] {
                                if let imageURL = images[images.count - 2]["#text"], imageURL.isEmpty == false {
                                    result.append(Artist(name: name , mbid: mbid ,  info: "no info", genre: "no genre", imageURL: URL(string:imageURL)!))
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    func processGetSimilarResult(_ resultData: AnyObject) -> [Artist] {
        var result: [Artist] = []

        if let similarDictionary = resultData["similarartists"] as? [String : AnyObject] {
            if let artistArray = similarDictionary["artist"] as? [AnyObject] {
                for artistData in artistArray {
                    if let artistData = artistData as? [String : AnyObject] {
                        if let name = artistData["name"] as? String, let mbid = artistData["mbid"] as? String, let images = artistData["image"] as? [[String : String]] {
                            if let imageURL = images[images.count - 3]["#text"], imageURL.isEmpty == false {
                                result.append(Artist(name: name , mbid: mbid ,  info: "no info", genre: "no genre", imageURL: URL(string:imageURL)!))
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    func processGetInfoResult(_ resultData: AnyObject) -> String {
        var result: String = ""

        if let artistDictionary = resultData["artist"] as? [String : AnyObject] {
            if let bioDictionary = artistDictionary["bio"] as? [String : AnyObject] {
                if let info = bioDictionary["summary"] as? String {
                    result = info
                }
            }
        }
        
        return result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
