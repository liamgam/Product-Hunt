//
//  CommentsViewController.swift
//  ProductHunt
//
//  Created by Rinni Swift on 2/15/19.
//  Copyright © 2019 Rinni Swift. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    
    // MARK: - Variables
    var comments: [Comment] = [] {
        didSet {
            commentsTableView.reloadData()
        }
    }
    var postId: Int!
    var networkManager = NetworkManager()

    // MARK: - Outlets
    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        updateComments()
    }
    
    // MARK: - Functions
    func updateComments() {
        networkManager.getCommments(postId) { (result) in
            switch result {
            case let .success(comments):
                self.comments = comments
            case .failure(_):
                print("error")
            }
        }
    }
    
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        let comment = comments[indexPath.row].body
        cell.commentTextView.text = comment
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
