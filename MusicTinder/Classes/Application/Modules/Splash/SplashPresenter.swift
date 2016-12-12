//
//  SplashPresenter.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

protocol SplashEventHandler : class {
}

class SplashPresenter {
    fileprivate weak var view: SplashView?
    fileprivate weak var router: SplashRouter?
    
    init (view: SplashView, router: SplashRouter) {
        self.view = view
        self.router = router
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.router?.displayLandingScreen()
        }
    }
}

extension SplashPresenter : SplashEventHandler {
}
