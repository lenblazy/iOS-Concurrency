//
//  UsersListView.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import SwiftUI

struct UsersListView: View {
    
#if DEBUG
    @StateObject var vm = UsersListViewModel(forPreview: true, apiService: ApiService(urlString: "https://jsonplaceholder.typicode.com/users"))
#else
    @StateObject var vm = UsersListViewModel(apiService: ApiService(urlString: "https://jsonplaceholder.typicode.com/users"))
#endif
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.usersAndPosts) { userAndPosts in
                    
                    NavigationLink{
                        PostsListView(posts: userAndPosts.posts)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(userAndPosts.user.name)
                                    .font(.title)
                                Spacer()
                                Text("(\(userAndPosts.numberOfPosts))")
                                    .padding()
                            }
                            Text(userAndPosts.user.email)
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
            .task {
                await vm.fetchUsers()
            }
            
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
