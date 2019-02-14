//
//  Post.swift
//  ProductHunt
//
//  Created by Rinni Swift on 2/11/19.
//  Copyright © 2019 Rinni Swift. All rights reserved.
//

import Foundation

struct Post {
    let id: Int
    let name: String
    let tagline: String
    let votesCount: Int
    let commentsCount: Int
    let previewImageUrl: URL
}

struct PostList: Decodable {
    var posts: [Post]
}

extension Post: Decodable {
    
    // matching the names with that of JSON's we are recieving
    enum PostKeys: String, CodingKey {
        case id
        case name
        case tagline
        case votesCount = "votes_count"
        case commentsCount = "comments_count"
        case previewImageUrl = "screenshot_url"
    }
    
    enum PreviewImageURLKeys: String, CodingKey {
        case imageUrl = "850px"
    }
    
    init(from decoder: Decoder) throws {
        // a container containing all the JSON data, and sub container containing all the sub data of a data
        let postContainer = try decoder.container(keyedBy: PostKeys.self)
        id = try postContainer.decode(Int.self, forKey: .id)
        name = try postContainer.decode(String.self, forKey: .name)
        tagline = try postContainer.decode(String.self, forKey: .tagline)
        votesCount = try postContainer.decode(Int.self, forKey: .votesCount)
        commentsCount = try postContainer.decode(Int.self, forKey: .commentsCount)
        
        let screenshotContainer = try postContainer.nestedContainer(keyedBy: PreviewImageURLKeys.self, forKey: .previewImageUrl)
        previewImageUrl = try screenshotContainer.decode(URL.self, forKey: .imageUrl)
    }
}
