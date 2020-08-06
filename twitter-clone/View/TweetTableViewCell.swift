//
//  TweetTableViewCell.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/7/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import Firebase
import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    private var model: TweetModel?
    
    func configure(with model: TweetModel) {
        self.model = model
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .named
        let dateString = formatter.localizedString(for: model.timestamp.dateValue(), relativeTo: Date())
        titleLabel.text = "@\(model.authorUsername) • \(dateString)"
        contentLabel.text = model.text
        likeButton.setTitle("\(model.likeCount) likes", for: .normal)
    }
    
    @IBAction func likeButtonDidPress() {
        guard let id = model?.id else { return }
        db.collection("tweets").document(id).updateData([
            "like_count": FieldValue.increment(Int64(1))
        ])
    }
}
