//
//  DiscoverViewController.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    weak var eventHandler: DiscoverEventHandler?
    @IBOutlet private weak var tableView: UITableView!
    private var artists = [Artist]()
    private var searchView: SearchView?
    private var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        registerCellNibs()
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if artists.isEmpty {
            return searchText != "" ? 1 : 0
        }

        return artists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if artists.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NoSearchResultsTableViewCell.self), for: indexPath) as? NoSearchResultsTableViewCell else { return UITableViewCell() }
            cell.searchText = searchText
            cell.eventHandler = eventHandler
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ArtistTableViewCell.self), for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
        let artist = artists[indexPath.row]
        cell.configureWithArtist(artist)

        // TODO: Implement
//        if let imageUrl = artist.imageUrl {
//            loadImageForCell(cell, imageURL: imageUrl)
//        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if artists.indices.contains(indexPath.row) {
            eventHandler?.artistSelected(artists[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchViewNibName = NSStringFromClass(SearchView.self)
        searchView = UINib(nibName: searchViewNibName.components(separatedBy: ".").last!, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SearchView
        searchView?.eventHandler = eventHandler
        return searchView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}

private extension DiscoverViewController {

    func registerCellNibs() {
        let artistTableViewCellNibName = NSStringFromClass(ArtistTableViewCell.self)
        let artistTableViewCellNib = UINib(nibName: artistTableViewCellNibName.components(separatedBy: ".").last!, bundle: nil)
        tableView?.register(artistTableViewCellNib, forCellReuseIdentifier: artistTableViewCellNibName)

        let noSearchResultsTableViewCellNibName = NSStringFromClass(NoSearchResultsTableViewCell.self)
        let noSearchResultsTableViewCellNib = UINib(nibName: noSearchResultsTableViewCellNibName.components(separatedBy: ".").last!, bundle: nil)
        tableView?.register(noSearchResultsTableViewCellNib, forCellReuseIdentifier: noSearchResultsTableViewCellNibName)

        let searchViewNibName = NSStringFromClass(SearchView.self)
        let searchViewNib = UINib(nibName: searchViewNibName.components(separatedBy: ".").last!, bundle: nil)
        tableView?.register(searchViewNib, forCellReuseIdentifier: searchViewNibName)
    }

    func customizeNavigationBar() {
        self.title = "DISCOVER"
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.applicationFontWithSize(16.0),
                                                                        .foregroundColor: UIColor.mtWhiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.mtBlackColor()
    }
}

extension DiscoverViewController: DiscoverView {

    func updateArtists(_ artists: [Artist]) {
        self.artists = artists
        tableView?.reloadData()
        tableView?.scrollRectToVisible(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), animated: true)
    }

    func updateSearchText(_ text: String) {
        searchText = text
    }
}
