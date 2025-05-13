//
//  WellnessCard.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 4/5/2025.
//


import SwiftUI

struct WellnessCard: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    let description: String
}

struct DailyWellnessView: View {
    @State private var dailyCards: [WellnessCard] = []
    @State private var flippedStates: [UUID: Bool] = [:]

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
                Text("Today's Wellness Cards")
                    .font(.title2)
                    .padding(.top)

                ForEach(dailyCards) { card in
                    FlipCardView(front: {
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
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }, back: {
                        Text(card.description)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }, isFlipped: flippedStates[card.id] ?? false)
                    .onTapGesture {
                        withAnimation {
                            flippedStates[card.id] = !(flippedStates[card.id] ?? false)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadDailyCards()
        }
    }

    private func loadDailyCards() {
        let today = Calendar.current.startOfDay(for: Date())
        let mockDate = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 5))!

        let savedDate = UserDefaults.standard.object(forKey: "lastWellnessDate") as? Date
        let savedCardIDs = UserDefaults.standard.array(forKey: "dailyWellnessIDs") as? [String]

        if let savedDate = savedDate, Calendar.current.isDate(savedDate, inSameDayAs: mockDate), let ids = savedCardIDs {
            dailyCards = allCards.filter { ids.contains($0.id.uuidString) }
            print("Loaded saved cards: \(dailyCards.map { $0.title })")
        } else {
            dailyCards = Array(allCards.shuffled().prefix(3))
            UserDefaults.standard.set(today, forKey: "lastWellnessDate")
            UserDefaults.standard.set(dailyCards.map { $0.id.uuidString }, forKey: "dailyWellnessIDs")
            print("Generated new daily cards: \(dailyCards.map { $0.title })")
        }

        flippedStates = Dictionary(uniqueKeysWithValues: dailyCards.map { ($0.id, false) })
    }

}
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
            front
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            
            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0)) // <— fix here
        }
        .animation(.spring(), value: isFlipped)
    }
}
