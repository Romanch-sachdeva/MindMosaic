//
//  BackgroundWrapper.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 4/5/2025.
//


import SwiftUI

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
