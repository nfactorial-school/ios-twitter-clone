//
//  ViewController.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/5/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var authActionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: BaseTextField!
    @IBOutlet weak var emailTextField: BaseTextField!
    @IBOutlet weak var passwordTextField: BaseTextField!
    @IBOutlet weak var authActionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "email"
        passwordTextField.placeholder = "password"
    }


}

class BaseTextField: UITextField {
    let placeholderColor = UIColor(red: 0.54, green: 0.59, blue: 0.64, alpha: 1.00)
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                       attributes: [.foregroundColor: placeholderColor])
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
    }
}
