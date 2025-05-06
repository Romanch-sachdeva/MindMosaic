//
//  UserManager.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 6/5/2025.
//



// UserManager.swift
import Foundation

class UserManager: ObservableObject {
    @Published var users: [User] = []
    @Published var loggedInUser: User?

    private let fileName = "users.json"

    init() {
        loadUsers()
    }

    func register(username: String, password: String) -> Bool {
        guard !users.contains(where: { $0.username == username }) else {
            return false // Username already exists
        }
        let newUser = User(username: username, password: password)
        users.append(newUser)
        saveUsers()
        return true
    }

    func login(username: String, password: String) -> Bool {
        if let user = users.first(where: { $0.username == username && $0.password == password }) {
            loggedInUser = user
            return true
        }
        return false
    }

    private func saveUsers() {
        do {
            let data = try JSONEncoder().encode(users)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try data.write(to: url)
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }

    private func loadUsers() {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url),
           let loadedUsers = try? JSONDecoder().decode([User].self, from: data) {
            self.users = loadedUsers
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
