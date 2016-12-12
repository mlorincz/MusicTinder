//
//  NoSearchResultsTableViewCell.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

private let badNewsText: String = "Unfortunately we didn't find anything for \"SEARCH_TEXT\" :("

class NoSearchResultsTableViewCell : UITableViewCell {
    
    @IBOutlet fileprivate weak var badNewsLabel: UILabel!
    weak var eventHandler: DiscoverEventHandler?

    var searchText: String = "" {
        didSet {
            badNewsLabel.text = badNewsText.replacingOccurrences(of: "SEARCH_TEXT", with: searchText)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func checkTopArtistsTapped() {
        eventHandler?.didTapSearch("")
    }
}
