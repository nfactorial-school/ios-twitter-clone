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

    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var action: Action = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        switch action {
        case .add:
            titleTextField.text = ""
            contentTextView.text = ""
        case .edit(let tweet):
            titleTextField.text = tweet.title
            contentTextView.text = tweet.content
        }
    }
    
    @IBAction func actionButtonDidPress(_ sender: UIButton) {
        switch action {
        case .add:
            performAddAction()
        case .edit(let tweet):
            performEditAction(tweet: tweet)
        }
    }

    @IBAction func cancelButtonDidPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func performAddAction() {
        guard let title = titleTextField.text, let content = contentTextView.text else {
            showError(with: "Fields should not be empty!")
            return
        }
        let tweet = TweetModel(title: title, content: content)
        do {
            let _ = try db.collection("tweets").addDocument(from: tweet)
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
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""
        let updatedTweet = TweetModel(title: title, content: content, likeCount: tweet.likeCount)
        do {
            try db.collection("tweets").document(tweetId).setData(from: updatedTweet)
            dismiss(animated: true, completion: nil)
        } catch {
            showError(with: error.localizedDescription)
        }
    }
}
