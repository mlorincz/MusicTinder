//
//  ArtistRoundedView.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 06/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class ArtistRoundedView: UIView {

    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    func loadArtistImage(_ artist: Artist?, completion: @escaping () -> Void) {
        guard let imageUrl = artist?.imageUrl else { return }

        if let cachedImage = imageUrl.cachedImage {
            loadingIndicator.isHidden = true
            self.artistImageView.image = cachedImage
            completion()
        } else {
            loadingIndicator.isHidden = false
            imageUrl.fetchImage({ [unowned self] image in
                self.loadingIndicator.isHidden = true
                self.artistImageView.image = image
                completion()
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.isHidden = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.mtWhiteColor().cgColor
        self.layer.cornerRadius = artistImageView.frame.size.height / 2.0
        self.layer.masksToBounds = true
    }

    func setImageViewAlpha(_ alpha: CGFloat) {
        guard artistImageView.alpha != alpha else { return }

        UIView.animate(withDuration: 0.3, animations: {
            self.artistImageView.alpha = alpha
        })
    }
}
