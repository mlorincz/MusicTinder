//
//  ChartService.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol GetTopArtistDelegate: class {
    func getTopArtistsFinishedWithResult(_ result: [Artist])
    func getTopArtistsFinishedWithError(_ error: String)
}

let DefaultTimeoutInterval = 20.0

class ChartService {
    private weak var getTopArtistDelegate: GetTopArtistDelegate?

    required init(getTopArtistDelegate: GetTopArtistDelegate) {
        self.getTopArtistDelegate = getTopArtistDelegate
    }

    func getTopArtists() {
        guard let urlString = URLProvider.topArtistsURL() else {
            getTopArtistDelegate?.getTopArtistsFinishedWithError("Error with urlString")
            return
        }

        guard let url = URL(string: urlString.appendResultFormat(.JSON)) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = DefaultTimeoutInterval

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, _, error) -> Void in

            guard error == nil else {
                self.loadGetTopArtistsCachedResponse()
                return
            }

            guard let data = data else {
                self.loadGetTopArtistsCachedResponse()
                return
            }

            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let artists = self.processResultData(jsonResult as AnyObject)

                if artists.isEmpty {
                    self.loadGetTopArtistsCachedResponse()
                } else {
                    self.getTopArtistDelegate?.getTopArtistsFinishedWithResult(self.processResultData(jsonResult as AnyObject))
                }
            } catch _ as NSError {
                self.loadGetTopArtistsCachedResponse()
            }
        }

        task.resume()
    }
}

private extension ChartService {

    func loadGetTopArtistsCachedResponse() {

        if let path = Bundle.main.path(forResource: "topArtists", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                getTopArtistDelegate?.getTopArtistsFinishedWithResult(processResultData(jsonResult as AnyObject))
            } catch let error as NSError {
                getTopArtistDelegate?.getTopArtistsFinishedWithError(error.localizedDescription)
            }
        } else {
            getTopArtistDelegate?.getTopArtistsFinishedWithError("Invalid filename/path")
        }
    }

    func processResultData(_ resultData: AnyObject) -> [Artist] {
        var result: [Artist] = []

        if let artistsDictionary = resultData["artists"] as? [String: AnyObject] {
            if let artistArray = artistsDictionary["artist"] as? [AnyObject] {

                for artistData in artistArray {

                    if let artistData = artistData as? [String: AnyObject] {
                        if let name = artistData["name"] as? String, let mbid = artistData["mbid"] as? String, let images = artistData["image"] as? [[String: String]] {
                            if let imageURL = images[images.count - 2]["#text"], imageURL.isEmpty == false {
                                result.append(Artist(name: name, mbid: mbid, info: "no info", genre: "no genre", imageUrl: URL(string: imageURL)!))
                            }
                        }
                    }
                }
            }
        }

        return result
    }
}
