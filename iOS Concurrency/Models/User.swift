//
//  User.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

// Source: https://jsonplaceholder.typicode.com/users

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
