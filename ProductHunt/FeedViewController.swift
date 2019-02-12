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
    var mockData: [Post] = {
        var meTube = Post(id: 0, name: "MeTube", tagline: "Stream videos for free!", votesCount: 25, commentsCount: 4)
        var boogle = Post(id: 1, name: "Boogle", tagline: "Search anything!", votesCount: 1000, commentsCount: 50)
        var meTunes = Post(id: 0, name: "MeTunes", tagline: "Listen to any song!", votesCount: 25000, commentsCount: 590)
        
        return [meTube, boogle, meTunes]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

}


extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
        let post = mockData[indexPath.row]
        cell.post = post
        return cell
    }
    
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
