//
//  TweetViewController.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/5/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func cancelButtonDidPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
