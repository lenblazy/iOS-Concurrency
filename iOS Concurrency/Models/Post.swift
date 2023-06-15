//
//  Post.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

// Source: https://jsonplaceholder.typicode.com/posts
// Single User's post: https://jsonplaceholder.typicode.com/users/1/posts

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
}
