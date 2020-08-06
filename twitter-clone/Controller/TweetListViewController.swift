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
    
    private var tweets: [Tweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatabaseListener()
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
    
    func setupDatabaseListener() {
        db.collection("tweets").addSnapshotListener { (snapshot, error) in
            if let error = error {
                self.showError(with: error.localizedDescription)
            } else if let documents = snapshot?.documents {
                self.tweets = documents.compactMap { (document) -> Tweet? in
                    var tweet = try? document.data(as: Tweet.self)
                    tweet?.id = document.documentID
                    return tweet
                }
            }
        }
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
        if tweet.authorId == Auth.auth().currentUser?.uid {
            performSegue(withIdentifier: "showTweet", sender: TweetViewController.Action.edit(tweet: tweet))
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
        action.backgroundColor = .lightBlue
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
