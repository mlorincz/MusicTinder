//
//  URLProvider.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

enum ResultFormat: String {
    case JSON = "&format=json"
    case XML = ""
}

struct URLProvider {
    private static let apiKey = "81c412de78ecc2616b61ec137f530ef8"

    // base URLs
    private static let lastFMBaseURL = "https://ws.audioscrobbler.com"
    private static let iTunesBaseURL = "https://itunes.apple.com"

    // Artist Service Endpoints
    private static let artistSearchEndpoint = "/2.0/?method=artist.search&artist=ARTIST_NAME&api_key=YOUR_API_KEY"
    private static let artistGetSimilarEndpoint = "/2.0/?method=artist.getsimilar&artist=ARTIST_NAME&api_key=YOUR_API_KEY"
    private static let artistGetInfoEndpoint = "/2.0/?method=artist.getinfo&artist=ARTIST_NAME&api_key=YOUR_API_KEY"

    // Chart Service Endpoints
    private static let chartGetTopArtistsEndpoint = "/2.0/?method=chart.gettopartists&api_key=YOUR_API_KEY"

    // iTunes Service Endpoints
    private static let iTunesArtistSearchEndpoint = "/search?term=ARTIST_NAME&entity=song"

    static func artistSearchURLString(_ artistName: String?) -> String? {
        var urlString = lastFMBaseURL + artistSearchEndpoint
        let validatedArtistName = artistName?.replacingOccurrences(of: " ", with: "+")
        urlString = urlString.replacingOccurrences(of: "ARTIST_NAME", with: validatedArtistName ?? "")
        urlString = urlString.replacingOccurrences(of: "YOUR_API_KEY", with: apiKey)

        print("[DOWNLOAD] - artist search from URL: \(urlString)")
        return urlString
    }

    static func similartArtistsURLString(_ artistName: String?) -> String? {
        var urlString = lastFMBaseURL + artistGetSimilarEndpoint
        let validatedArtistName = artistName?.replacingOccurrences(of: " ", with: "+")
        urlString = urlString.replacingOccurrences(of: "ARTIST_NAME", with: validatedArtistName ?? "")
        urlString = urlString.replacingOccurrences(of: "YOUR_API_KEY", with: apiKey)

        print("[DOWNLOAD] - similar artists from URL: \(urlString)")
        return urlString
    }

    static func artistInfoURLString(_ artistName: String?) -> String? {
        var urlString = lastFMBaseURL + artistGetInfoEndpoint
        let validatedArtistName = artistName?.replacingOccurrences(of: " ", with: "+")
        urlString = urlString.replacingOccurrences(of: "ARTIST_NAME", with: validatedArtistName ?? "")
        urlString = urlString.replacingOccurrences(of: "YOUR_API_KEY", with: apiKey)

        print("[DOWNLOAD] - artist info from URL: \(urlString)")
        return urlString
    }

    static func iTunesAtistURLString(_ artistName: String?) -> String? {
        var urlString = iTunesBaseURL + iTunesArtistSearchEndpoint
        let validatedArtistName = artistName?.replacingOccurrences(of: " ", with: "+")
        urlString = urlString.replacingOccurrences(of: "ARTIST_NAME", with: validatedArtistName ?? "")

        print("[DOWNLOAD] - iTunes artist from URL: \(urlString)")
        return urlString
    }

    static func topArtistsURL() -> String? {
        var urlString = lastFMBaseURL + chartGetTopArtistsEndpoint
        urlString = urlString.replacingOccurrences(of: "YOUR_API_KEY", with: apiKey)

        print("[DOWNLOAD] - top artists from URL: \(urlString)")
        return urlString
    }
}

extension String {

    func appendResultFormat(_ format: ResultFormat) -> String {
        return self + format.rawValue
    }
}
