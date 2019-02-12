//
//  PostTableViewCell.swift
//  ProductHunt
//
//  Created by Rinni Swift on 2/11/19.
//  Copyright © 2019 Rinni Swift. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            nameLabel.text = post.name
            commentsLabel.text = "Comments: \(post.commentsCount)"
            votesLabel.text = "Votes: \(post.votesCount)"
            updatePreviewImage()
        }
    }
    
    func updatePreviewImage() {
        guard let post = post else { return }
        previewImageView.image = UIImage(named: "placeholder")
    }
    
}
