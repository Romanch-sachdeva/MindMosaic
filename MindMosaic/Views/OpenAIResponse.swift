//
//  OpenAIResponse.swift
//  MindMosaic
//


import Foundation

struct OpenAIResponse: Codable {
    let id: String
    let choices: [Choice]

    struct Choice: Codable {
        let index: Int
        let message: Message
        let finish_reason: String?
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}
