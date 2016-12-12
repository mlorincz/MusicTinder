//
//  ArtistListViewController.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class ArtistListViewController : UIViewController {
    
    weak var eventHandler: ArtistListEventHandler?
    @IBOutlet fileprivate weak var discoverButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var artists = [Artist]()
    fileprivate var selectedIndexPath: IndexPath?
    
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
        let artistTableViewCellNib = UINib(nibName:artistTableViewCellNibName.components(separatedBy: ".").last!, bundle: nil)
        tableView?.register(artistTableViewCellNib, forCellReuseIdentifier:artistTableViewCellNibName)
    }

    func customizeNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationFontWithSize(16.0), NSForegroundColorAttributeName : UIColor.mtWhiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.mtBlackColor()
    }

    func customizeDiscoverButton() {
        discoverButton.layer.cornerRadius = 5.0
    }
    
    func loadImageForCell(_ cell: ArtistTableViewCell, imageURL: URL) {
        
        cell.imageUrl = imageURL
        
        if let image = imageURL.cachedImage {
            cell.artistImageView.image = image
            cell.artistImageView.alpha = 1
            cell.loadingIndicatorView.alpha = 0
        }
        else {
            cell.artistImageView.alpha = 0
            imageURL.fetchImage { image in
                
                if cell.imageUrl == imageURL {
                    cell.artistImageView.image = image
                    cell.loadingIndicatorView.alpha = 0
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.artistImageView.alpha = 1
                    }) 
                }
            }
        }
    }
}

extension ArtistListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ArtistTableViewCell.self), for: indexPath) as! ArtistTableViewCell
        let artist = artists[indexPath.row]
        cell.configureWithArtist(artist)
        cell.textLabel?.font = UIFont.applicationFontWithSize(12.0)
        loadImageForCell(cell, imageURL: artist.imageURL as URL)
        
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
        let deleteButton = UITableViewRowAction(style: .default, title: "\u{0020} \u{0020} \u{0020} \u{0020} \u{0020} \u{0020} \u{0020}") { action, index in
            self.tableView(tableView, commit: UITableViewCellEditingStyle.delete, forRowAt: indexPath)
        }
        
        deleteButton.backgroundColor = UIColor(patternImage: UIImage(named: "delete_action_purple_icon_150")!)
        
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            eventHandler?.didDeleteArtist(artists[indexPath.row])
            artists.remove(at: indexPath.row)
            updateAppearance()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}

extension ArtistListViewController : ArtistListView {
    
    func updateArtists(_ artists: [Artist]) {
        self.artists = artists
        self.tableView?.reloadData()
    }
}
