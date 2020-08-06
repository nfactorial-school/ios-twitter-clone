//
//  ViewController.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/5/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import Firebase
import UIKit

class AuthViewController: UIViewController {
    
    enum Action {
        case signUp
        case logIn
    }
    
    @IBOutlet weak var authActionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var authActionButton: UIButton!
    @IBOutlet weak var textFieldsStackView: UIStackView!
    @IBOutlet weak var usernameTextField: BaseTextField!
    @IBOutlet weak var emailTextField: BaseTextField!
    @IBOutlet weak var passwordTextField: BaseTextField!
    
    private let animationDuration: TimeInterval = 0.25
    private var currentAction: Action = .signUp {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        emailTextField.placeholder = "email"
        usernameTextField.placeholder = "username"
        passwordTextField.placeholder = "password"
        passwordTextField.isSecureTextEntry = true
        authActionSegmentedControl.selectedSegmentTintColor = .mainWhite
        authActionSegmentedControl.backgroundColor = .dirtyBlue
        authActionSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.grayish], for: .normal)
        authActionSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.dirtyBlue], for: .selected)
    }
    
    func updateUI() {
        switch currentAction {
        case .signUp:
            UIView.animate(withDuration: animationDuration) {
                self.usernameTextField.isHidden = false
                self.usernameTextField.alpha = 1
                self.authActionButton.setTitle("Sign up", for: .normal)
            }
        case .logIn:
            UIView.animate(withDuration: animationDuration) {
                self.usernameTextField.isHidden = true
                self.usernameTextField.alpha = 0
                self.authActionButton.setTitle("Log in", for: .normal)
            }
        }
    }
    
    @IBAction func authActionDidChange() {
        if authActionSegmentedControl.selectedSegmentIndex == 0 {
            currentAction = .signUp
        } else {
            currentAction = .logIn
        }
    }
    
    @IBAction func authActionButtonDidPress() {
        switch currentAction {
        case .signUp:
            performSignUpAction()
        case .logIn:
            performLogInAction()
        }
    }
    
    func performLogInAction() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else {
            showError(with: "Fields should not be empty!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.showError(with: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "showTweets", sender: nil)
            }
        }
    }
    
    func performSignUpAction() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text else {
            showError(with: "Fields should not be empty!")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.showError(with: error.localizedDescription)
            } else if let user = authResult?.user {
                let updateRequest = user.createProfileChangeRequest()
                updateRequest.displayName = username
                updateRequest.commitChanges { (error) in
                    if let error = error {
                        self.showError(with: error.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: "showTweets", sender: nil)
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func showError(with message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

class LoadingButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loader)
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
    
    
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
    }
}
