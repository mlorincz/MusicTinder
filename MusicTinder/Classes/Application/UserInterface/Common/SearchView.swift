//
//  SearchView.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class SearchView : UIView {
    
    weak var eventHandler: DiscoverEventHandler?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var goButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeGoButton()
        customizeSearchBar()
    }
    
    @IBAction func goButtonTapped() {
        eventHandler?.didTapSearch(searchBar.text ?? "")
    }
}

private extension SearchView {
    
    func customizeGoButton() {
        goButton.layer.cornerRadius = 5.0
    }
    
    func customizeSearchBar() {
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        
        guard let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField else {
            return
        }

        textFieldInsideUISearchBar.font = UIFont.applicationFontWithSize(12.0)
        textFieldInsideUISearchBar.textColor = UIColor.mtGrayColor()
        
        guard let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar.value(forKey: "placeholderLabel") as? UILabel else {
            return
        }
        
        textFieldInsideUISearchBarLabel.font = UIFont.applicationFontWithSize(12.0)
        textFieldInsideUISearchBarLabel.textColor = UIColor.mtGrayColor()
    }
}

extension SearchView : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        eventHandler?.didTapSearch(searchBar.text ?? "")
    }
}
