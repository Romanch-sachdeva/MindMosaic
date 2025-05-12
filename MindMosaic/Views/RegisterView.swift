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
        ZStack{
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.iceColdBlue)
            
            VStack(spacing: 20) {
                Text("Register")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundStyle(.regularMaterial)
                
                Spacer()
                
                Image(systemName: "person.crop.circle.badge.plus")
                                        .font(.system(size: 60, weight: .light))
                                        .foregroundColor(.white.opacity(0.9))
                                        .padding(.bottom, 4)
                
                TextField("Username", text: $username)
                                            .textFieldStyle(.plain)
                                            .safeAreaInset(edge: .leading, content: {Image(systemName: "person")})
                                            .padding()
                                            .background(Color.white.opacity(0.80))
                                            .cornerRadius(12)
                                            .frame(width: 300)
                                            .autocapitalization(.none)
                                            
                
                SecureField("Password", text: $password)
                                           .textFieldStyle(.plain)
                                           .safeAreaInset(edge: .leading, content: {Image(systemName: "lock")})
                                           .padding()
                                           .background(Color.white.opacity(0.80))
                                           .cornerRadius(12)
                                           .frame(width: 300)
                
                
                if !error.isEmpty {
                    Text(error).foregroundColor(.red)
                }
                
                Button{
                    if username.isEmpty {
                        error = "Username is empty"
                    }
                    else if password.isEmpty {
                        error = "Password is empty"
                    }
                    else if userManager.register(username: username, password: password) {
                        dismiss()
                    } else {
                        error = "Username already exists"
                    }
                } label: {
                    Text("Create Account")
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .cornerRadius(26)
                        .padding(.horizontal, 20)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                }
                .padding()
                Spacer()
            }
            .padding()
        }
    }
}


