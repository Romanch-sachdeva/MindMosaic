//
//  RegisterView.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 6/5/2025.
//



// RegisterView.swift
import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss

    @State private var username = ""
    @State private var password = ""
    @State private var error = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.title)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !error.isEmpty {
                Text(error).foregroundColor(.red)
            }

            Button("Create Account") {
                if userManager.register(username: username, password: password) {
                    dismiss()
                } else {
                    error = "Username already exists"
                }
            }
            .padding()
        }
        .padding()
    }
}