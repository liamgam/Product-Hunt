//
//  FeedViewController.swift
//  ProductHunt
//
//  Created by Rinni Swift on 2/11/19.
//  Copyright © 2019 Rinni Swift. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    // MARK - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK - Variables
    var posts: [Post] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        updateFeed()
    }
    
    func updateFeed() {
        networkManager.getPost() { (result) in
            switch result {
            case let .success(posts):
                self.posts = posts
            case let .failure(error):
                print(error)
            }
        }
    }

}


extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let commentsView = storyBoard.instantiateViewController(withIdentifier: "commentsView") as? CommentsViewController else { return }
        commentsView.postId = post.id
        navigationController?.pushViewController(commentsView, animated: true)
    }
}
