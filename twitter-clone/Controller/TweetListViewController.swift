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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        // Hide separators for empty rows
//        tableView.tableFooterView = UIView()
    }
        
    @IBAction func addButtonDidPress() {
        performSegue(withIdentifier: "showTweet", sender: TweetViewController.Action.add)
    }
    
    @IBAction func logoutButtonDidPresss() {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Immediately deselect
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
