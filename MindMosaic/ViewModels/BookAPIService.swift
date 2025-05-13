//
//  BookAPIService.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 10/5/2025.
//
import Foundation

class BookAPIService {
    static let shared = BookAPIService()

    func searchBooks(query: String = "self help", completion: @escaping ([Book]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://openlibrary.org/search.json?q=\(encodedQuery)&subject=Meditation") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error:", error ?? "")
                completion([])
                return
            }

            do {
                let response = try JSONDecoder().decode(BookResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.docs)
                }
            } catch {
                print("Decoding error:", error)
                completion([])
            }
        }.resume()
    }
}
