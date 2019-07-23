//
//  ArtistTableViewCell.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!

    private let mockImageUrl = URL(string: "http://assets.blabbermouth.net/media/childrenofbodommarch2018rehearsal_638.jpg")

    override func prepareForReuse() {
        super.prepareForReuse()
        loadingIndicatorView.alpha = 1
        loadingIndicatorView.startAnimating()
    }

    func configure(with artist: Artist) {
        artistNameLabel.text = artist.name
        artistImageView.sd_setImage(with: mockImageUrl) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.loadingIndicatorView.stopAnimating()
            self.loadingIndicatorView.isHidden = true
        }
    }
}
