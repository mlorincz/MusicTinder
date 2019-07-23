//
//  ArtistNameLabel.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class ArtistNameLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0.0, left: 10.0, bottom: 0.0, right: 48.0)
        super.drawText(in: rect.inset(by: insets))
    }
}
