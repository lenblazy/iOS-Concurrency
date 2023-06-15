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
    @Published var showAlert = false
    @Published var errorMsg: String?
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    @MainActor
    func fetchUsers() async {
        isLoading.toggle()
        defer{
            isLoading.toggle()
        }
        do{
            users = try await apiService.getJSON()
        } catch{
            showAlert.toggle()
            errorMsg = error.localizedDescription
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
