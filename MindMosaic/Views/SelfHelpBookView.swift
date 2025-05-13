//
//  SelfHelpBookView.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 10/5/2025.
//


import SwiftUI

struct SelfHelpBookView: View {
    @State private var books: [Book] = []
    @State private var searchText = ""
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack {
                    HStack {
                        TextField("Search for books...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button("Search") {
                            searchBooks()
                        }
                        .padding(.trailing)
                    }
                    
                    if isLoading {
                        ProgressView("Loading...")
                            .padding()
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(books) { book in
                                HStack(alignment: .top) {
                                    if let url = book.coverImageURL {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 120)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 80, height: 120)
                                        }
                                    } else {
                                        Image(systemName: "book")
                                            .resizable()
                                            .frame(width: 80, height: 120)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(book.title)
                                            .font(.headline)
                                        Text(book.author)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        if let link = book.openLibraryURL {
                                            Link(destination: link) {
                                                Text("Read Book")
                                                    .font(.caption)
                                                    .foregroundColor(.blue)
                                                    .padding(6)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color.blue, lineWidth: 1)
                                                    )
                                            }
                                            .padding(.top, 4)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Self-Help Books")
            .onAppear {
                searchBooks()
            }
        }
    }

    private func searchBooks() {
        isLoading = true
        BookAPIService.shared.searchBooks(query: searchText.isEmpty ? "self help" : searchText) { books in
            self.books = books
            isLoading = false
        }
    }
}
