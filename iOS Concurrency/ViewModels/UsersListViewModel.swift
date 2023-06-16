//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import Foundation


class UsersListViewModel: ObservableObject {
    
    @Published var usersAndPosts: [UserAndPost] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMsg: String?
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    @MainActor
    func fetchUsers() async {
        let apiService2 = ApiService(urlString: "https://jsonplaceholder.typicode.com/posts")
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        do {
            async let users: [User] = try await apiService.getJSON()
            async let posts: [Post] = try await apiService2.getJSON()
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
            
            for user in fetchedUsers {
                let userPosts = fetchedPosts.filter { $0.userId == user.id }
                let newUserAndPosts = UserAndPost(user: user, posts: userPosts)
                usersAndPosts.append(newUserAndPosts)
            }
        } catch {
            showAlert.toggle()
            errorMsg = error.localizedDescription
        }
    }
    
}

extension UsersListViewModel{
    
    convenience init(forPreview: Bool = false, apiService: ApiService) {
        self.init(apiService: apiService)
        if forPreview{
            self.usersAndPosts = UserAndPost.mockUserAndPosts
        }
    }
    
}
