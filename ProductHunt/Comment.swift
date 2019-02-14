//
//  Comment.swift
//  ProductHunt
//
//  Created by Rinni Swift on 2/14/19.
//  Copyright © 2019 Rinni Swift. All rights reserved.
//

import Foundation


struct Comment: Decodable {
    let id: Int
    let body: String
}

struct CommentAPIResult: Decodable {
    let comments: [Comment]
}
