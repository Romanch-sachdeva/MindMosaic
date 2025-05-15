//
//  MindfulnessMedia.swift
//  MindMosaic

import Foundation

// mindful item and med
struct MindfulnessMedia: Identifiable {
    let id = UUID()
    let title: String
    let type: MediaType
    let thumbnail: String
    let resource: String
}

enum MediaType {
    case audio
    case video
}
