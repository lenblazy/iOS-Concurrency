//
//  PostsListView.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import SwiftUI

struct PostsListView: View {
    
    #if DEBUG
    @StateObject var vm = PostListViewModel(forPreview: true)
    #else
    @StateObject var vm = PostListViewModel()
    #endif
    
    var userId: Int
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.callout)
                        .foregroundColor(.secondary)
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
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .task{
            await vm.fetchPosts()
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostsListView(userId: 1)
        }
        
    }
}
