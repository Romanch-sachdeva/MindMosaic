//
//  OpenAIService.swift
//  MindMosaic
//



import Foundation

// check with openrouter ai service
//key needs to be changed
// if error thrown key has expired
class OpenRouterService {
    static let shared = OpenRouterService()
    private let apiKey = "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"

    func getResponse(for userInput: String) async -> String {
           guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
               return "Invalid URL"
           }

           let headers = [
               "Content-Type": "application/json",
               "Authorization": "Bearer \(apiKey)"
           ]

           let systemMessage = [
               "role": "system",
               "content": "You are a supportive and empathetic mental wellness assistant."
           ]
           let userMessage = [
               "role": "user",
               "content": userInput
           ]

        
           let body: [String: Any] = [
               "model": "openai/gpt-3.5-turbo",
               "messages": [systemMessage, userMessage],
               "temperature": 0.8
           ]

           guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
               return "Failed to encode body"
           }

            // amke req
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.allHTTPHeaderFields = headers
           request.httpBody = bodyData

           do {
               let (data, _) = try await URLSession.shared.data(for: request)

               //json for bedug
               if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                   print("RAW JSON:\n", json)
               }

               let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
               return result.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No message returned"
           } catch {
               print("Decode Error: \(error)")
               return "Failed to decode response"
           }
       }
   }
