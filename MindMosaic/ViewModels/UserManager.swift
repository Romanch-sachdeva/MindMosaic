//
//  UserManager.swift
//  MindMosaic



import Foundation
import CryptoKit

// hash password
func hashPassword(_ password: String) -> String {
    let inputData = Data(password.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}


// for user rego, login
class UserManager: ObservableObject {
    @Published var users: [User] = []
    @Published var loggedInUser: User?

    private let fileName = "users.json"

    init() {
        loadUsers()
    }

    func register(username: String, password: String) -> Bool {
        guard !users.contains(where: { $0.username == username }) else {
            return false
        }
        guard isPasswordStrong(password) else {
            return false
        }

        let hashedPassword = hashPassword(password)
        let newUser = User(username: username, passwordHash: hashedPassword)
        users.append(newUser)
        saveUsers()
        return true
    }

    func login(username: String, password: String) -> Bool {
        let hashedPassword = hashPassword(password)
        if let user = users.first(where: { $0.username == username && $0.passwordHash == hashedPassword }) {
            loggedInUser = user
            return true
        }
        return false
    }

    //saves user in file per file
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
