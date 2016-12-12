//
//  ArtistDetailViewController.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 12/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class ArtistDetailViewController : UIViewController {
    @IBOutlet fileprivate weak var artistImageView: UIImageView!
    @IBOutlet fileprivate weak var artistBioLabel: UILabel!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var artistImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var artistLabel: ArtistNameLabel!
    @IBOutlet fileprivate weak var songInfoView: UIView!
    @IBOutlet fileprivate weak var songNameLabel: UILabel!
    @IBOutlet fileprivate weak var artistNameLabel: UILabel!
    @IBOutlet fileprivate weak var collectionImageview: UIImageView!
    @IBOutlet fileprivate weak var bufferingLabel: UILabel!
    @IBOutlet fileprivate weak var listenButton: UIButton!

    fileprivate var artistImageViewBaseHeight: CGFloat = 0.0
    fileprivate var artist: Artist?
    fileprivate var song: Song?
    fileprivate var artistBio: String?

    weak var eventHandler: ArtistDetailEventHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        customizeUI()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        eventHandler?.didTapBackButton()
    }
    
    @IBAction func listenButtonTapped() {
        eventHandler?.didTapListen()
    }
    
    @IBAction func songInfoButtonTapped() {
        let alert = UIAlertController(title: "Leave MusicTinder?", message: "Open this artist in \"iTunes Store\"?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) -> Void in
            print("[INFO] - Dismiss UIAlertController")
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) -> Void in
            self.eventHandler?.didTapITunesButton()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }
}

private extension ArtistDetailViewController {
    
    func customizeNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.mtBlackColor()
        navigationItem.applyNavigationItem(withImageName: "nav_bar_logo")
    }
    
    func customizeUI() {
        artistImageViewBaseHeight = artistImageViewHeightConstraint.constant
        scrollView.contentInset.top = -64.0
        listenButton.layer.cornerRadius = 5.0
        songInfoView.layer.cornerRadius = 5.0
        listenButton.alpha = 0.0
        bufferingLabel.alpha = 0.0
        songInfoView.alpha = 0.0
    }
    
    func loadArtistImage(_ artist: Artist?, completion: @escaping (_ image: UIImage) -> ()) {
        
        if let cachedImage = artist?.imageURL.cachedImage {
            completion(cachedImage)
        }
        else {
            artist?.imageURL.fetchImage({ image in
                completion(image)
            })
        }
    }
    
    func resizeImage(_ image: UIImage) -> UIImage {
        let rect = CGRect(x: 0.0, y: 50.0, width: 300.0, height: 150.0)
        let imageRef = image.cgImage?.cropping(to: rect)
        
        return UIImage(cgImage: imageRef!)
    }
    
    func updateUI() {
        loadArtistImage(artist) { [unowned self] (image: UIImage) in
            self.artistImageView?.image = self.resizeImage(image)
        }
        
        artistLabel?.text = artist?.name
        artistBioLabel?.text = artistBio ?? ""
    }
    
    func hideArtistLabel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.artistLabel.alpha = 0.0
        }) 
    }
    
    func showArtistLabel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.artistLabel.alpha = 1.0
        }) 
    }
    
    func customizeSongInfoView() {
        artistNameLabel.text = song?.artistName
        songNameLabel.text = song?.trackName
        
        if let cachedImage = song?.artworkUrl100?.cachedImage {
            collectionImageview.image = cachedImage
        }
        else {
            song?.artworkUrl100?.fetchImage({ [unowned self] image in
                self.collectionImageview.image = image
            })
        }
    }
}

extension ArtistDetailViewController : ArtistDetailView {
    
    func updateArtist(_ artist: Artist) {
        self.artist = artist
        updateUI()
    }
    
    func updateSong(_ song: Song) {
        self.song = song
        customizeSongInfoView()
    }
    
    func showButteringLabel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bufferingLabel.alpha = 1.0
        }) 
    }
    
    func hideBufferingLabel() {
        self.showSongInfoView()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bufferingLabel.alpha = 0.0
            self.listenButton.alpha = 1.0
        }) 
    }
    
    func toggleListenButton(_ isPaused: Bool) {
        listenButton.backgroundColor = isPaused ? UIColor.mtGrayColor() : UIColor.mtGreenColor()
        listenButton.setTitle(isPaused ? "PAUSE" : "LISTEN" , for: UIControlState())
    }
    
    func showSongInfoView() {
        UIView.animate(withDuration: 1.0, animations: {
            self.songInfoView.alpha = 1.0
        }) 
    }
    
    func hideSongInfoView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.songInfoView.alpha = 0.0
            self.listenButton.alpha = 0.0
            self.artistLabel.alpha = 0.0
        }) 
    }
    
    func updateArtistInfo(_ info: String) {
        artistBio = info
        artistBioLabel?.text = artistBio ?? ""
    }
}

extension ArtistDetailViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        var artistImageFrame = artistImageView.frame
        
        if (scrollOffset < 0) {
            artistImageFrame.size.height = 200.0 - ((scrollOffset / 3));
            artistImageView.frame = artistImageFrame;
            hideArtistLabel()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showArtistLabel()
    }
}
