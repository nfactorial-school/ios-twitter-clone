//
//  TweetListViewController.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/5/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import FirebaseFirestoreSwift
import Firebase
import UIKit

class TweetListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var tweets: [TweetModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        db.collection("tweets").addSnapshotListener { (snapshot, error) in
            if let error = error {
                self.showError(with: error.localizedDescription)
            } else if let documents = snapshot?.documents {
                self.tweets = documents.compactMap { (document) -> TweetModel? in
                    var tweet = try? document.data(as: TweetModel.self)
                    tweet?.id = document.documentID
                    return tweet
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "showTweet",
            let action = sender as? TweetViewController.Action,
            let destinationNavigationViewController = segue.destination as? UINavigationController,
            let tweetViewController = destinationNavigationViewController.viewControllers.first as? TweetViewController else { return }
        tweetViewController.action = action
    }
    
    func setupUI() {
        navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addButtonDidPress() {
        performSegue(withIdentifier: "showTweet", sender: TweetViewController.Action.add)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.configure(with: tweets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tweet = tweets[indexPath.row]
        performSegue(withIdentifier: "showTweet", sender: TweetViewController.Action.edit(tweet: tweet))
        if tweet.authorId == Auth.auth().currentUser?.uid {
        } else {
            showError(with: "You can not edit other person's tweet:(")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tweet = tweets[indexPath.row]
        guard tweet.authorId == Auth.auth().currentUser?.uid else {
            return nil
        }
        let action = UIContextualAction(
            style: .normal,
            title: "Edit",
            handler: { (action, view, completion) in
                self.performSegue(withIdentifier: "showTweet", sender: TweetViewController.Action.edit(tweet: tweet))
                completion(true)
        })
        action.backgroundColor = .systemBlue
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    private var model: TweetModel?
    
    func configure(with model: TweetModel) {
        self.model = model
        titleLabel.text = model.title
        contentLabel.text = model.content
        likeButton.setTitle("Likes: \(model.likeCount)", for: .normal)
    }
    
    @IBAction func likeButtonDidPress() {
        guard let id = model?.id else { return }
        db.collection("tweets").document(id).updateData([
            "like_count": FieldValue.increment(Int64(1))
        ])
    }
}

struct TweetModel: Codable {
    var id: String?
    let title: String
    let content: String
    let timestamp: Timestamp
    let likeCount: Int
    let authorId: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case timestamp
        case likeCount = "like_count"
        case authorId = "author_uid"
    }
    
    init(title: String, content: String, likeCount: Int = 0) {
        self.title = title
        self.content = content
        self.timestamp = Timestamp(date: Date())
        self.likeCount = likeCount
        self.authorId = Auth.auth().currentUser!.uid
    }
}
