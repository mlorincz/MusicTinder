//
//  LoadingView.swift
//  SimpleNewsfeed
//
//  Created by Mate Lorincz on 2019. 07. 12..
//  Copyright © 2019. MateLorincz. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    static let shared = LoadingView()

    private var isPresenting: Bool = false

    private override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    private convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func show() {
        guard !isPresenting else { return }
        isPresenting = true

        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            let keyWindow = UIApplication.shared.keyWindow!
            self?.frame = keyWindow.bounds
            keyWindow.addSubview(self!)
            keyWindow.bringSubviewToFront(self!)

            UIView.animate(withDuration: 0.3, animations: {
                self?.alpha = 1.0
            })
        })
    }

    func hide() {
        guard isPresenting else { return }

        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            UIView.animate(
                withDuration: 0.3,
                animations: { self?.alpha = 0.0 },
                completion: { (_) in
                    self?.isPresenting = false
                    self?.removeFromSuperview()
                }
            )
        })
    }
}

// MARK: - Private Extension

private extension LoadingView {

    func configureUI() {
        backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        alpha = 0.0

        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)
        activityIndicatorView.center = center
    }
}
