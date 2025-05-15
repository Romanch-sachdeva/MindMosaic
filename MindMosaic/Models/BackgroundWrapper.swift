//
//  BackgroundWrapper.swift
//  MindMosaic


import SwiftUI

// for background
struct BackgroundWrapper<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("SoftBlue"), Color("LightLavender")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            content
                .padding()
        }
    }
}
