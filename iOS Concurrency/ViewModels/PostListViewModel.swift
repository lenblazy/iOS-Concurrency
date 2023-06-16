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
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMsg: String?
    
    func fetchPosts() async{
        isLoading.toggle()
        
        defer{
            isLoading.toggle()
        }
        if let id = userId{
            let apiService = ApiService(urlString: "https://jsonplaceholder.typicode.com/users/\(id)/posts")
            do{
                posts = try await apiService.getJSON()
            } catch{
                showAlert.toggle()
                errorMsg = error.localizedDescription
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

