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
    let urlSession = URLSession.shared
    var baseUrl = "https://api.producthunt.com/v1/"
    var token = "4cc7bd39cc3185105c61645107b3f04b1d720d2f5779e2c78c2b1c241a073d28"
    
    // allows compiler to continue on other code and return later on when the data is ready to be returned
    func getPost(completion: @escaping (Result<[Post]>) -> Void) {
        let postsRequest = makeRequest(for: .posts)
        let task = urlSession.dataTask(with: postsRequest) { data, response, error in
            
            if let error = error {
                return completion(Result.failure(error))
            }
            guard let data = data else {
                return completion(Result.failure(endPointError.noData))
            }
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return completion(Result.failure(endPointError.couldNotParse))
            }
            let posts = result.posts
            
            DispatchQueue.main.async {
                completion(Result.success(posts))
            }
        }
        task.resume()
    }
    
    func getCommments(_ postId: Int, completion: @escaping (Result<[Comment]>) -> Void) {
        let commentRequest = makeRequest(for: .comments(postId: postId))
        let task = urlSession.dataTask(with: commentRequest) { data, response, error in
            if let error = error {
                return completion(Result.failure(error))
            }
            guard let data = data else {
                return completion(Result.failure(endPointError.noData))
            }
            guard let result = try? JSONDecoder().decode(CommentAPIResult.self, from: data) else {
                return completion(Result.failure(endPointError.couldNotParse))
            }
            DispatchQueue.main.async {
                completion(Result.success(result.comments))
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
    
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        let stringParams = endPoint.paramsToString()
        let path = endPoint.getPath()
        let fullUrl = URL(string: baseUrl.appending("\(path)?\(stringParams)"))!
        var request = URLRequest(url: fullUrl)
        request.httpMethod = endPoint.getHttpMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(token: token)
        
        return request
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum endPointError: Error {
        case couldNotParse
        case noData
    }
    
}
