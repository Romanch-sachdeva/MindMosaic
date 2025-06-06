//
//  Book.swift
//  MindMosaic

import Foundation

//get single book(s) from openlib api
// get author
struct Book: Identifiable, Decodable {
    var id: String { key }

    let key: String
    let title: String
    let author_name: [String]?
    let cover_i: Int?

    var coverImageURL: URL? {
        guard let coverId = cover_i else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg")
    }

    var author: String {
        author_name?.first ?? "Unknown Author"
    }
    
    var openLibraryURL: URL? {
        URL(string: "https://openlibrary.org\(key)")
    }

}

// api response
struct BookResponse: Decodable {
    let docs: [Book]
}
