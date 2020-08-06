//
//  TweetViewController.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/5/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import FirebaseFirestoreSwift
import UIKit

class TweetViewController: UIViewController {
    
    enum Action {
        case add
        case edit
    }

    @IBOutlet weak var textView: UITextView!
    
    var action: Action = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func setupUI() {
        switch action {
        case .add:
            title = "Add tweet"
            textView.text = ""
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(actionButtonDidPress(_:)))
            doneButton.tintColor = .white
            navigationItem.rightBarButtonItem = doneButton
        case .edit:
            title = "Edit tweet"
            textView.text = ""
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: #selector(actionButtonDidPress(_:)))
            saveButton.tintColor = .white
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @IBAction func cancelButtonDidPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func actionButtonDidPress(_ sender: UIButton) {
        switch action {
        case .add:
            performAddAction()
        case .edit:
            performEditAction()
        }
    }

    func performAddAction() {
        
    }
    
    func performEditAction() {
        
    }
}
