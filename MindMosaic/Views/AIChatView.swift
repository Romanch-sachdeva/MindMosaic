//
//  AIChatView.swift
//  MindMosaic
//



import SwiftUI

// ai help page
struct AIChatView: View {
    @State private var userInput = ""
    @State private var messages: [ChatMessage] = []
    @State private var isLoading = false
    @Namespace private var bottomID

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(messages) { msg in
                                HStack {
                                    if msg.isUser {
                                        Spacer()
                                        ChatBubble(message: msg.text, isUser: true)
                                    } else {
                                        ChatBubble(message: msg.text, isUser: false)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // dots when ai coming up with something
                            if isLoading {
                                HStack {
                                    TypingIndicator()
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            
                            Color.clear
                                .frame(height: 1)
                                .id(bottomID)
                        }
                        .padding(.vertical)
                        .onChange(of: messages.count) { _ in
                            withAnimation {
                                proxy.scrollTo(bottomID)
                            }
                        }
                    }
                }
                
                HStack {
                    TextField("Share how you feel...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isLoading)
                    
                    Button {
                        Task { await sendMessage() }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(userInput.isEmpty || isLoading)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
            }
            .navigationTitle("Wellness Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func sendMessage() async {
        let userText = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userText.isEmpty else { return }

        messages.append(ChatMessage(text: userText, isUser: true))
        userInput = ""
        isLoading = true

        let aiResponse = await OpenRouterService.shared.getResponse(for: userText)
        messages.append(ChatMessage(text: aiResponse, isUser: false))

        isLoading = false
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}



//chat msg bubble
struct ChatBubble: View {
    let message: String
    let isUser: Bool

    var body: some View {
        Text(message)
            .padding(12)
            .background(isUser ? Color.blue : Color.green.opacity(0.2))
            .foregroundColor(isUser ? .white : .black)
            .cornerRadius(16)
            .frame(maxWidth: 300, alignment: isUser ? .trailing : .leading)
    }
}

// typing typing...
struct TypingIndicator: View {
    @State private var dotCount = 1
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { i in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.gray.opacity(0.6))
                    .scaleEffect(dotCount > i ? 1 : 0.5)
                    .animation(.easeInOut(duration: 0.3), value: dotCount)
            }
        }
        .onReceive(timer) { _ in
            dotCount = dotCount % 3 + 1
        }
        .padding(10)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}
