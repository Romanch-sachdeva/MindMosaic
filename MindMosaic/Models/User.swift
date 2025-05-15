//
//  User.swift
//  MindMosaic


import Foundation


// user name and password but hashed
struct User: Codable, Identifiable {
    let id = UUID()
    let username: String
    let passwordHash: String
}
