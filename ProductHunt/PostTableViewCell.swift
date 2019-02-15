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
            taglineLabel.text = post.tagline
            updatePreviewImage()
        }
    }
    
    func updatePreviewImage() {
        guard let post = post else { return }
        URLSession.shared.dataTask(with: post.previewImageUrl) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.previewImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
}
