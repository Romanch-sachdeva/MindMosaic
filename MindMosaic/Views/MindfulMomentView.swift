//
//  MindfulMomentView.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 1/5/2025.
//


import SwiftUI

struct MindfulMomentView: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Breathe In… Breathe Out")
                    .font(.title)
                
                Circle()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 150, height: 150)
                    .scaleEffect(scale)
                    .animation(
                        .easeInOut(duration: 4).repeatForever(autoreverses: true),
                        value: scale
                    )
                    .onAppear {
                        scale = 1.4
                    }
                
                Text("Take a moment to center yourself with us")
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}
