//
//  NetworkManager.swift
//  ProductHunt
//
//  Created by Rinni Swift on 2/12/19.
//  Copyright © 2019 Rinni Swift. All rights reserved.
//

import Foundation


class NetworkManager {
    
    // MARK: - Variables
//    let urlSession = URLSession.shared
    var baseUrl = "https://api.producthunt.com/v1/"
    var token = "4cc7bd39cc3185105c61645107b3f04b1d720d2f5779e2c78c2b1c241a073d28"
    
    // allows compiler to continue on other code and return later on when the data is ready to be returned
    func getPost(completion: @escaping ([Post]) -> Void) {
        let queery = "/posts/all?sort_by=votes_count&order=desc&search[featured]=true&per_page=20"
        let fullUrl = URL(string: baseUrl + queery)!
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)",
            "Host": "api.producthunt.com"
        ]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else { return }
            let posts = result.posts
            
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        task.resume()
    }
    
    
    enum EndPoints {
        case posts
        case comments(postId: Int)
        
        func getPath() -> String {
            switch self {
            case .posts:
                return "posts/all"
            case .comments:
                return "comments"
            }
        }
        
        func getHttpMethod() -> String {
            return "GET"
        }
        
        func getHeaders(token: String) -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)",
                "Host": "api.producthunt.com"
            ]
        }
        
        func getParams() -> [String: String] {
            switch self {
            case .posts:
                return [
                    "sort_by": "votes_count",
                    "order": "desc",
                    "per_page": "20",
                    
                    "search[featured]": "true"
                ]
                
            case let .comments(postId):
                return [
                    "sort_by": "votes",
                    "order": "asc",
                    "per_page": "20",
                    
                    "search[post_id]": "\(postId)"
                ]
            }
        }
        
        func paramsToString() -> String {
            let parameterArray = getParams().map { key, value in
                return "\(key)=\(value)"
            }
            
            return parameterArray.joined(separator: "&")
        }
    }
    
}
