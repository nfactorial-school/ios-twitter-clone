//
//  Tweet.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/7/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import Firebase
import Foundation

struct Tweet: Codable {
    var id: String?
    let authorUsername: String
    let authorId: String
    let text: String
    let timestamp: Timestamp
    let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case text
        case timestamp
        case likeCount = "like_count"
        case authorUsername = "author_username"
        case authorId = "author_uid"
    }
    
    // It is not really suggested nor encouraged to place calls to `Auth` and stuff directly to the plain models - but it stays here for the sake of simplicity :)
    init(text: String) {
        self.text = text
        self.authorUsername = Auth.auth().currentUser!.displayName!
        self.timestamp = Timestamp(date: Date())
        self.likeCount = 0
        self.authorId = Auth.auth().currentUser!.uid
    }
}
