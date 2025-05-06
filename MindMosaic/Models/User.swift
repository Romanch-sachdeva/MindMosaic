//
//  User.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 6/5/2025.
//


// User.swift
import Foundation

struct User: Codable, Identifiable {
    let id = UUID()
    let username: String
    let password: String
}