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
    @IBOutlet weak var authActionButton: LoadingButton!
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
        performSegue(withIdentifier: "showTweets", sender: nil)
        switch currentAction {
        case .signUp:
            performSignUpAction()
        case .logIn:
            performLogInAction()
        }
    }
    
    func performLogInAction() {
    }
    
    func performSignUpAction() {
    }
}
