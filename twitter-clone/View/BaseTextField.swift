//
//  BaseTextField.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/7/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                       attributes: [.foregroundColor: UIColor.grayish])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        textColor = .white
        backgroundColor = .dirtyBlue
    }
}
