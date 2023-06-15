//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import Foundation


class UsersListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func fetchUsers()  {
        apiService.getJSON { (result: Result<[User], APIError>) in
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

extension UsersListViewModel{
    
    convenience init(forPreview: Bool = false, apiService: ApiService) {
        self.init(apiService: apiService)
        if forPreview{
            self.users = User.mockUsers
        }
    }
    
}
