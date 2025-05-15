//
//  WellnessCard.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 15/5/2025.
//


//
//  WellnessCard.swift
//  MindMosaic

import SwiftUI

// Model representing a wellness card with a unique id, title, image, and description
struct WellnessCard: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    let description: String
}

struct DailyWellnessView: View {
    // State for the cards shown daily
    @State private var dailyCards: [WellnessCard] = []
    // Tracks whether each card is flipped or not
    @State private var flippedStates: [UUID: Bool] = [:]

    // A fixed list of all available wellness cards
    private let allCards: [WellnessCard] = [
        WellnessCard(title: "Downward Dog", imageName: "yoga1", description: "A full-body stretch improving flexibility."),
        WellnessCard(title: "Tree Pose", imageName: "yoga2", description: "Enhances balance and stability."),
        WellnessCard(title: "Meditation Sit", imageName: "med1", description: "Sit cross-legged and focus on breathing."),
        WellnessCard(title: "Child's Pose", imageName: "yoga3", description: "A gentle resting pose to relieve stress."),
        WellnessCard(title: "Breathing Focus", imageName: "med2", description: "Inhale deeply for 4 seconds, exhale for 6."),
        WellnessCard(title: "Sun Salutation", imageName: "yoga4", description: "A flow of poses to energize your body.")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title text at the top of the view
                Text("Today's Wellness Cards")
                    .font(.title2)
                    .padding(.top)

                // Iterate through the daily cards and display flip cards for each
                ForEach(dailyCards) { card in
                    FlipCardView(front: {
                        // Front of the card: image and title
                        VStack {
                            Image(card.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                            Text(card.title)
                                .font(.headline)
                                .padding(.top, 5)
                        }
                        .padding()
                        .background(.ultraThinMaterial) // translucent background material
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }, back: {
                        // Back of the card: description text
                        Text(card.description)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }, isFlipped: flippedStates[card.id] ?? false) // track flip state
                    .onTapGesture {
                        // Toggle the flipped state with animation when tapped
                        withAnimation {
                            flippedStates[card.id] = !(flippedStates[card.id] ?? false)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            // Load daily cards when the view appears
            loadDailyCards()
        }
    }

    // Loads the wellness cards for the day, preserving daily selection via UserDefaults
    private func loadDailyCards() {
        // Today's date normalized to start of day
        let today = Calendar.current.startOfDay(for: Date())
        // Mock date for testing or fixed behavior - May 5, 2025
        let mockDate = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 5))!

        // Retrieve the last saved date and saved card IDs from UserDefaults
        let savedDate = UserDefaults.standard.object(forKey: "lastWellnessDate") as? Date
        let savedCardIDs = UserDefaults.standard.array(forKey: "dailyWellnessIDs") as? [String]

        // Check if saved data exists and is for the same day as the mock date
        if let savedDate = savedDate,
           Calendar.current.isDate(savedDate, inSameDayAs: mockDate),
           let ids = savedCardIDs {
            // Load saved cards by filtering allCards by saved IDs
            dailyCards = allCards.filter { ids.contains($0.id.uuidString) }
            print("Loaded saved cards: \(dailyCards.map { $0.title })")
        } else {
            // Otherwise, pick a new random selection of 3 cards for today
            dailyCards = Array(allCards.shuffled().prefix(3))
            // Save today's date and the selected card IDs
            UserDefaults.standard.set(today, forKey: "lastWellnessDate")
            UserDefaults.standard.set(dailyCards.map { $0.id.uuidString }, forKey: "dailyWellnessIDs")
            print("Generated new daily cards: \(dailyCards.map { $0.title })")
        }

        // Initialize all cards' flip states as not flipped
        flippedStates = Dictionary(uniqueKeysWithValues: dailyCards.map { ($0.id, false) })
    }

}

// A generic flip card view that shows front or back based on flip state with 3D rotation animation
struct FlipCardView<Front: View, Back: View>: View {
    var front: Front
    var back: Back
    var isFlipped: Bool

    init(@ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back, isFlipped: Bool) {
        self.front = front()
        self.back = back()
        self.isFlipped = isFlipped
    }

    var body: some View {
        ZStack {
            // Front face of the card
            front
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Back face of the card
            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0)) // flip rotation
        }
        .animation(.spring(), value: isFlipped) // spring animation for flipping
    }
}
