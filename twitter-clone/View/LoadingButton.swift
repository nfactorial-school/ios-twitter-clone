//
//  LoadingButton.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/7/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    var originalButtonText: String?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func showLoading() {
        originalButtonText = titleLabel?.text
        setTitle("", for: .normal)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
}
