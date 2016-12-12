//
//  SplashViewController.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

class SplashViewController : UIViewController {
    
    weak var eventHandler: SplashEventHandler?
    @IBOutlet fileprivate weak var loadingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLoadingview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoadingView()
    }
}

private extension SplashViewController {

    func customizeLoadingview() {
        loadingView.layer.cornerRadius = 5.0
        loadingView.alpha = 0.0
    }
    
    func showLoadingView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 1.0
        }) 
    }
}

extension SplashViewController : SplashView {
    
}
