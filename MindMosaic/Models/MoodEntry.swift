//
//  MoodEntry.swift
//  MindMosaic



import Foundation

// mood item entry takes date, mood, text from user
struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let mood: String
    let note: String
}
