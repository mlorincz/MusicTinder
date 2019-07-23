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
    @IBOutlet private weak var artistsTableView: UITableView!

    private var artists = [Artist]()
    private var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        configureUI()
        registerCellNibs()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        artistsTableView?.contentInset.top = topLayoutGuide.length
        updateAppearance()

        if artists.isEmpty == false && selectedIndexPath == .none {
            artistsTableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - IBActions

private extension ArtistListViewController {

    @IBAction func discoverButtonTapped() {
        eventHandler?.didTapDiscoverButton()
    }
}

// MARK: - Private Extension

private extension ArtistListViewController {

    func configureUI() {
        customizeNavigationBar()
        discoverButton.layer.cornerRadius = 5.0
    }

    func updateAppearance() {
        artistsTableView?.backgroundColor = artists.isEmpty ? .clear : .mtBlackColor()
        self.title = "ARTIST LIBRARY"
    }

    func registerCellNibs() {
        let artistTableViewCellNibName = NSStringFromClass(ArtistTableViewCell.self)
        let artistTableViewCellNib = UINib(nibName: artistTableViewCellNibName.components(separatedBy: ".").last!, bundle: nil)
        artistsTableView?.register(artistTableViewCellNib, forCellReuseIdentifier: artistTableViewCellNibName)
    }

    func customizeNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.applicationFontWithSize(16.0),
                                                                        .foregroundColor: UIColor.mtWhiteColor()]
        self.navigationController?.navigationBar.barTintColor = .mtBlackColor()
    }
}

// MARK: - UITableViewDataSource

extension ArtistListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ArtistTableViewCell.self), for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
        let artist = artists[indexPath.row]
        cell.configure(with: artist)
        cell.textLabel?.font = UIFont.applicationFontWithSize(12.0)
        return cell
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

// MARK: - UITableViewDelegate

extension ArtistListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler?.didSelectArtist(artists[indexPath.row])
        selectedIndexPath = indexPath
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "\u{0020} \u{0020} \u{0020} \u{0020} \u{0020} \u{0020} \u{0020}") { _, _ in
            self.tableView(tableView, commit: UITableViewCell.EditingStyle.delete, forRowAt: indexPath)
        }

        deleteButton.backgroundColor = UIColor(patternImage: UIImage(named: "delete_action_purple_icon_150")!)

        return [deleteButton]
    }
}

// MARK: - ArtistListView

extension ArtistListViewController: ArtistListView {

    func updateArtists(_ artists: [Artist]) {
        self.artists = artists
        artistsTableView?.reloadData()
    }
}
