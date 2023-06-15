//
//  PostListViewModel.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import Foundation

class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    var userId: Int?
    
    func fetchPosts(){
        if let userId = userId{
            let apiService = ApiService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            
            apiService.getJSON { (result: Result<[Post], APIError>) in
                switch result{
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts.append(contentsOf: posts)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        
    }
}

extension PostListViewModel{
    
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview{
            self.posts = Post.mockSinglePostArray
        }
    }
    
}

