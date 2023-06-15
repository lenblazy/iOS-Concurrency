//
//  UsersListView.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import SwiftUI

struct UsersListView: View {
    
#if DEBUG
    @StateObject var vm = UsersListViewModel(forPreview: false, apiService: ApiService(urlString: "https://jsonplaceholder.typicode.com/users"))
#else
    @StateObject var vm = UsersListViewModel(apiService: ApiService(urlString: "https://jsonplaceholder.typicode.com/users"))
#endif
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in
                    
                    NavigationLink{
                        PostsListView(userId: user.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
                        }
                    }
                }
            }
            .overlay(content: {
                if vm.isLoading {
                    ProgressView()
                }
            })
            .alert("Application Error", isPresented: $vm.showAlert, actions: {
                Button("OK") { }
            }, message: {
                if let errorMsg = vm.errorMsg{
                    Text(errorMsg)
                }
            })
            .navigationTitle("Users")
            .listStyle(.plain)
            .onAppear{
                vm.fetchUsers()
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
