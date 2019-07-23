//
//  ArtistListViewController.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class ArtistListViewController: UIViewController {

    weak var eventHandler: ArtistListEventHandler?
    @IBOutlet private weak var discoverButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    private var artists = [Artist]()
    private var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        customizeDiscoverButton()
        registerCellNibs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler?.fetchPersistedArtists()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.contentInset.top = topLayoutGuide.length
        updateAppearance()

        if artists.isEmpty == false && selectedIndexPath == .none {
            tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }

    @IBAction func discoverButtonTapped() {
        eventHandler?.handleDiscoverTapped()
    }
}

private extension ArtistListViewController {

    func updateAppearance() {
        tableView?.backgroundColor = artists.isEmpty ? UIColor.clear : UIColor.mtBlackColor()
        self.title = "ARTIST LIBRARY"
    }

    func registerCellNibs() {
        let artistTableViewCellNibName = NSStringFromClass(ArtistTableViewCell.self)
        let artistTableViewCellNib = UINib(nibName: artistTableViewCellNibName.components(separatedBy: ".").last!, bundle: nil)
        tableView?.register(artistTableViewCellNib, forCellReuseIdentifier: artistTableViewCellNibName)
    }

    func customizeNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.applicationFontWithSize(16.0),
                                                                        .foregroundColor: UIColor.mtWhiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.mtBlackColor()
    }

    func customizeDiscoverButton() {
        discoverButton.layer.cornerRadius = 5.0
    }
}

extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ArtistTableViewCell.self), for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
        let artist = artists[indexPath.row]
        cell.configureWithArtist(artist)
        cell.textLabel?.font = UIFont.applicationFontWithSize(12.0)

        // TODO: Implement
//        if let imageUrl = artist.imageUrl {
//            loadImageForCell(cell, imageURL: imageUrl)
//        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if artists.indices.contains(indexPath.row) {
            print("[DEBUG] - push artist detail: \(artists[indexPath.row].name)")
            eventHandler?.artistSelected(artists[indexPath.row])
            selectedIndexPath = indexPath
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "\u{0020} \u{0020} \u{0020} \u{0020} \u{0020} \u{0020} \u{0020}") { _, _ in
            self.tableView(tableView, commit: UITableViewCell.EditingStyle.delete, forRowAt: indexPath)
        }

        deleteButton.backgroundColor = UIColor(patternImage: UIImage(named: "delete_action_purple_icon_150")!)

        return [deleteButton]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            eventHandler?.didDeleteArtist(artists[indexPath.row])
            artists.remove(at: indexPath.row)
            updateAppearance()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ArtistListViewController: ArtistListView {

    func updateArtists(_ artists: [Artist]) {
        self.artists = artists
        self.tableView?.reloadData()
    }
}
