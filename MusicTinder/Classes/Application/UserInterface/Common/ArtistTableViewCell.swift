//
//  ArtistTableViewCell.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class ArtistTableViewCell : UITableViewCell {
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var imageUrl: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingIndicatorView.alpha = 1
        loadingIndicatorView.startAnimating()
    }
    
    func configureWithArtist(_ artist: Artist?) {
        
        if let artist = artist {
            nameLabel.text = artist.name
        }
    }
}
