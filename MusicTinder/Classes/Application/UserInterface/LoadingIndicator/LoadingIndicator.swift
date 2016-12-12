//
//  LoadingIndicator.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

private let loadingIndicator = LoadingIndicator()

class LoadingIndicator {
    
    fileprivate var isPresenting = false
    fileprivate let loadingIndicatorView : LoadingIndicatorView?
    fileprivate let keyWindow : UIWindow = UIApplication.shared.keyWindow!
    
    init() {
        let loadingIndicatorViewNibName = NSStringFromClass(LoadingIndicatorView.self)
        loadingIndicatorView = UINib(nibName: loadingIndicatorViewNibName.components(separatedBy: ".").last!, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? LoadingIndicatorView
    }
    
    fileprivate func presentLoadingIndicator() {
        isPresenting = true
        
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            if let indicatorView = self.loadingIndicatorView {
                indicatorView.frame = self.keyWindow.bounds
                indicatorView.loadingIndicatorView.startAnimating()
                self.keyWindow.addSubview(indicatorView)
                self.keyWindow.bringSubview(toFront: indicatorView)
            }
        })
    }
    
    fileprivate func dismissLoadingIndicator() {
        
        DispatchQueue.main.async(execute: { [unowned self] () -> Void in
            self.loadingIndicatorView?.loadingIndicatorView.stopAnimating()
            self.loadingIndicatorView?.removeFromSuperview()
            self.isPresenting = false
        })
    }
}

extension LoadingIndicator {
    
    static func presentLoadingIndicator() {
        
        if loadingIndicator.isPresenting {
            return
        }
        
        loadingIndicator.presentLoadingIndicator()
    }
    
    static func dismissLoadingIndicator() {
        
        if loadingIndicator.isPresenting {
            loadingIndicator.dismissLoadingIndicator()
        }
    }
}
