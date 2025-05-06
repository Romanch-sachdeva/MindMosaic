//
//  MindfulnessMedia.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 4/5/2025.
//
import Foundation

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
