//
//  TinderViewController.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 06/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class TinderViewController : UIViewController {
    
    weak var eventHandler: TinderEventHandler?
    
    @IBOutlet fileprivate weak var artistScrollView: UIScrollView!
    @IBOutlet fileprivate weak var greenView: UIView!
    @IBOutlet fileprivate weak var messageOverlayView: UIView!
    @IBOutlet fileprivate weak var messageOverlayLabel: UILabel!
    @IBOutlet fileprivate weak var redView: UIView!
    @IBOutlet fileprivate weak var artistLabel: UILabel!
    
    @IBOutlet fileprivate weak var listenButton: UIButton!
    @IBOutlet weak var bufferingLabel: UILabel!

    @IBOutlet weak var songInfoView: UIView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionImageview: UIImageView!
    @IBOutlet weak var songInfoViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var artist: Artist?
    fileprivate var song: Song?
    fileprivate var greenGradientLayer = CAGradientLayer()
    fileprivate var redGradientLayer = CAGradientLayer()
    fileprivate var artistRoundedView: ArtistRoundedView?
    fileprivate var placeholderView = UIView()
    fileprivate var isAutoPlayOn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        artistLabel?.text = artist?.name
        loadGradientLayersDeafultState()
        customizeGradientViews()
        customizeListenButton()
        customizeNavigationBar()
        customizeAutoPlayButton()
        loadScrollView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        eventHandler?.didTapBackButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFrames()
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

private extension TinderViewController {
    
    func customizeGradientViews() {
        greenView.layer.insertSublayer(greenGradientLayer, at: 0)
        redView.layer.insertSublayer(redGradientLayer, at: 0)
    }
    
    func loadGradientLayersDeafultState() {
        greenView.alpha = 1.0
        redView.alpha = 1.0

        greenGradientLayer.frame = greenView.bounds
        greenGradientLayer.colors = [UIColor.mtGreenColor().cgColor, UIColor.clear.cgColor]
        greenGradientLayer.startPoint = CGPoint.zero;
        greenGradientLayer.endPoint = CGPoint(x: 0.2, y: 0);
        
        redGradientLayer.frame = redView.bounds
        redGradientLayer.colors = [UIColor.mtPurpleColor().cgColor, UIColor.clear.cgColor]
        redGradientLayer.startPoint = CGPoint(x: 1, y: 0);
        redGradientLayer.endPoint = CGPoint(x: 0.8, y: 0);
    }
    
    func customizeListenButton() {
        listenButton.layer.cornerRadius = 5.0
    }
    
    func customizeNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.mtBlackColor()
        navigationItem.applyNavigationItem(withImageName: "nav_bar_logo")
    }
    
    func customizeSongInfoView() {
        songInfoView.layer.cornerRadius = 5.0
        artistNameLabel.text = song?.artistName
        songNameLabel.text = song?.trackName
        songInfoViewHeightConstraint.constant = listenButton.isHidden ? 160.0 : 80.0

        if let cachedImage = song?.artworkUrl100?.cachedImage {
            collectionImageview.image = cachedImage
        }
        else {
            song?.artworkUrl100?.fetchImage({ [unowned self] image in
                self.collectionImageview.image = image
            })
        }
    }
    
    func loadScrollView() {
        let artistRoundedViewNibName = NSStringFromClass(ArtistRoundedView.self)
        artistRoundedView = UINib(nibName: artistRoundedViewNibName.components(separatedBy: ".").last!, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ArtistRoundedView
        artistRoundedView?.loadArtistImage(artist, completion: {
            self.hideMessage()
            UIView.animate(withDuration: 0.3, animations: { 
                self.artistLabel.alpha = 1.0
            })
        })
        artistScrollView.addSubview(placeholderView)
        artistScrollView.addSubview(artistRoundedView!)
    }
    
    func updateFrames() {
        greenGradientLayer.frame = greenView.bounds
        redGradientLayer.frame = redView.bounds
        placeholderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: artistScrollView.frame.size.height / 2.0, height: artistScrollView.frame.size.height))
        artistRoundedView?.frame = CGRect(x: placeholderView.frame.size.width, y: 0.0, width: artistScrollView.frame.size.height, height: artistScrollView.frame.size.height)
    }
    
    func customizeAutoPlayButton() {
        let autoPlaySwitch = UISwitch()
        autoPlaySwitch.addTarget(self, action: #selector(toggleAutoPlay(_:)), for: .valueChanged)
        let barButton = UIBarButtonItem(customView: autoPlaySwitch)
        self.navigationItem.rightBarButtonItem = barButton
    }

    @objc func toggleAutoPlay(_ sender: UISwitch) {
        eventHandler?.didTapAutoPlay(sender.isOn)
    }
}

extension TinderViewController : TinderView {
    
    func updateArtist(_ artist: Artist) {
        self.artist = artist
        artistLabel?.text = artist.name
        artistNameLabel?.text = artist.name
        
        UIView.animate(withDuration: 0.3, animations: {
            self.artistLabel?.alpha = 1.0
        })

        artistRoundedView?.loadArtistImage(artist, completion: {
            self.hideMessage()
        })
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
    
    func updateIsAutoPlay(_ isOn: Bool) {
        isAutoPlayOn = isOn
        listenButton.isHidden = isOn
        toggleListenButton(isOn)
        
        songInfoViewHeightConstraint.constant = listenButton.isHidden ? 160.0 : 80.0
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.view.layoutIfNeeded()
        }) 
    }
}

extension TinderViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.isDragging && artistRoundedView?.artistImageView.alpha != 0.5 {
            UIView.animate(withDuration: 0.3, animations: {
                self.artistRoundedView?.artistImageView.alpha = 0.5
            }) 
        }
        
        if scrollView.contentOffset.x < 0 {
            let gradientOffset = max(1.0 - abs(scrollView.contentOffset.x) / 100.0, 0.0)
            redGradientLayer.endPoint = CGPoint(x: max(0.8 - (1.0 - gradientOffset), 0.0), y: 0);
            greenGradientLayer.endPoint = CGPoint(x: 0.2, y: 0);
            artistRoundedView?.layer.borderColor = UIColor.mtPurpleColor().cgColor
        }
        else {
            let gradientOffset = max(1.0 - scrollView.contentOffset.x / 100.0, 0.0)
            greenGradientLayer.endPoint = CGPoint(x: min(0.2 + 1.0 - gradientOffset, 1.0), y: 0);
            redGradientLayer.endPoint = CGPoint(x: 0.8, y: 0);
            artistRoundedView?.layer.borderColor = UIColor.mtGreenColor().cgColor
        }
        
        if scrollView.contentOffset.x == 0 {
            artistRoundedView?.layer.borderColor = UIColor.mtWhiteColor().cgColor
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.artistRoundedView?.artistImageView.alpha = 0.5
        }) 
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.artistRoundedView?.artistImageView.alpha = 1.0
        }) 
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.frame.size.width / 7.0 - scrollView.contentOffset.x <= 0 {
            scrollView.setContentOffset(scrollView.contentOffset, animated: true)
            
            hideSongInfoView()
            showGreenMessage({
                scrollView.setContentOffset(CGPoint.zero, animated: false)
                self.artistRoundedView?.alpha = 1.0
                self.eventHandler?.didSwipeArtist(true)
            })
        }
        else if scrollView.frame.size.width / 7.0 - abs(scrollView.contentOffset.x) <= 0 {
            scrollView.setContentOffset(scrollView.contentOffset, animated: true)

            hideSongInfoView()
            showRedMessage({
                scrollView.setContentOffset(CGPoint.zero, animated: false)
                self.artistRoundedView?.alpha = 1.0
                self.eventHandler?.didSwipeArtist(false)
            })
        }
    }
    
    func showGreenMessage(_ completion: @escaping () -> ()) {
        self.messageOverlayView.backgroundColor = UIColor.mtGreenColor()
        greenGradientLayer.startPoint = CGPoint.zero;
        greenGradientLayer.endPoint = CGPoint(x: 1.0, y: 0);
        
        UIView.animate(withDuration: 0.5, animations: {
            self.artistRoundedView?.alpha = 0.0
            self.redView.alpha = 0.0
            self.messageOverlayView.alpha = 1.0
            }, completion: { (_) in
                let array = ["AWESOME", "YEAH BABY", "AMAZING", "COOL", "INCREDABLE", "IMPRESSIVE"]
                let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
                self.showMessage(array[randomIndex])
                completion()
        })
    }
    
    func showRedMessage(_ completion: @escaping () -> ()) {
        self.messageOverlayView.backgroundColor = UIColor.mtPurpleColor()
        redGradientLayer.startPoint = CGPoint(x: 1, y: 0);
        redGradientLayer.endPoint = CGPoint(x: 0.0, y: 0);
        
        UIView.animate(withDuration: 0.5, animations: {
            self.artistRoundedView?.alpha = 0.0
            self.greenView.alpha = 0.0
            self.messageOverlayView.alpha = 1.0
            }, completion: { (_) in
                let array = ["NOT NOW", "LATER", "SKIP", "NEXT TIME"]
                let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
                self.showMessage(array[randomIndex])
                completion()
        })
    }
    
    func showMessage(_ text: String) {
        self.messageOverlayLabel.text = text
        
        UIView.animate(withDuration: 0.5, animations: {
            self.messageOverlayLabel.alpha = 1.0
        }, completion: { (_) in
            self.hideMessage()
            self.loadGradientLayersDeafultState()
        })
    }
    
    func hideMessage() {
        UIView.animate(withDuration: 1.0, animations: {
            self.messageOverlayView.alpha = 0.0
        }, completion: { (_) in
            self.messageOverlayLabel.alpha = 0.0
        })
    }
}
