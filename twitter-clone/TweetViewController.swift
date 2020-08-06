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
        case edit(tweet: TweetModel)
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
        case .edit(let tweet):
            title = "Edit tweet"
            textView.text = tweet.text
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
        case .edit(let tweet):
            performEditAction(tweet: tweet)
        }
    }

    func performAddAction() {
        guard let text = textView.text, !text.isEmpty else {
            showError(with: "Content should not be empty!")
            return
        }
        do {
            let _ = try db.collection("tweets").addDocument(from: TweetModel(text: text))
            dismiss(animated: true, completion: nil)
        } catch {
            showError(with: error.localizedDescription)
        }
    }
    
    func performEditAction(tweet: TweetModel) {
        guard let tweetId = tweet.id else {
            showError(with: "Corrupted data: tweet needs to have and id!")
            dismiss(animated: true, completion: nil)
            return
        }
        guard let text = textView.text, !text.isEmpty else {
            showError(with: "Content should not be empty!")
            return
        }
        db.collection("tweets").document(tweetId).updateData(["text": text]) { (error) in
            if let error = error {
                self.showError(with: error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
