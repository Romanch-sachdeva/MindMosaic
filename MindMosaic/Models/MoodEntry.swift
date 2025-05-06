//
//  MoodEntry.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 1/5/2025.
//


import Foundation

struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let mood: String
    let note: String
}
