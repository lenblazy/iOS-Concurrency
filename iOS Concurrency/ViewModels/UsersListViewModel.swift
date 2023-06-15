//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import Foundation


class UsersListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func fetchUsers()  {
        isLoading.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.apiService.getJSON { (result: Result<[User], APIError>) in
                defer{
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
                switch result{
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users.append(contentsOf: users)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
}

extension UsersListViewModel{
    
    convenience init(forPreview: Bool = false, apiService: ApiService) {
        self.init(apiService: apiService)
        if forPreview{
            self.users = User.mockUsers
        }
    }
    
}
