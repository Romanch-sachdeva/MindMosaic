//
//  MindfulnessCenterView.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 4/5/2025.
//

import SwiftUI
import AVKit

struct MindfulnessCenterView: View {
    @State private var selectedMedia: MindfulnessMedia?
    @State private var dailyCards: [WellnessCard] = []
    @State private var flippedStates: [UUID: Bool] = [:]

    let mindfulnessMediaItems: [MindfulnessMedia] = [
        MindfulnessMedia(title: "Calming Breath", type: .video, thumbnail: "calm_breath_thumb", resource: "calm_breath"),
        MindfulnessMedia(title: "Ocean Sleep Sounds", type: .audio, thumbnail: "ocean_thumb", resource: "ocean_sleep"),
        MindfulnessMedia(title: "Gentle Stretch", type: .video, thumbnail: "stretch_thumb", resource: "gentle_stretch"),
        MindfulnessMedia(title: "Forest Ambience", type: .audio, thumbnail: "forest_thumb", resource: "forest_ambience")
    ]

    private let allCards: [WellnessCard] = [
        WellnessCard(title: "Downward Dog", imageName: "yoga1", description: "A full-body stretch improving flexibility."),
        WellnessCard(title: "Tree Pose", imageName: "yoga2", description: "Enhances balance and stability."),
        WellnessCard(title: "Meditation Sit", imageName: "med1", description: "Sit cross-legged and focus on breathing."),
        WellnessCard(title: "Child's Pose", imageName: "yoga3", description: "A gentle resting pose to relieve stress."),
        WellnessCard(title: "Breathing Focus", imageName: "med2", description: "Inhale deeply for 4 seconds, exhale for 6."),
        WellnessCard(title: "Sun Salutation", imageName: "yoga4", description: "A flow of poses to energize your body.")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Sleep Sounds
                        Text("Sound Meditation")
                            .font(.title2)
                            .padding(.leading)

                        ForEach(mindfulnessMediaItems.filter { $0.type == .audio }) { item in
                            mediaRow(for: item)
                        }

                        Divider()

                        // Mindful Videos
                        Text("Mindful Videos")
                            .font(.title2)
                            .padding(.leading)

                        ForEach(mindfulnessMediaItems.filter { $0.type == .video }) { item in
                            mediaRow(for: item)
                        }

                        Divider()

                        // Yogic Meditation Cards
                        Text("Yogic Meditation")
                            .font(.title2)
                            .padding(.leading)

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
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Mindfulness Center")
            .sheet(item: $selectedMedia) { media in
                if media.type == .video {
                    VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: media.resource, withExtension: "mp4")!))
                        .edgesIgnoringSafeArea(.all)
                } else {
                    AudioPlayerView(resource: media.resource)
                }
            }
            .onAppear {
                loadDailyCards()
            }
        }
    }


    @ViewBuilder
    private func mediaRow(for item: MindfulnessMedia) -> some View {
        HStack {
            Image(item.thumbnail)
                .resizable()
                .frame(width: 80, height: 50)
                .cornerRadius(8)
            Text(item.title)
            Spacer()
            Image(systemName: item.type == .video ? "video.fill" : "music.note")
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .padding(.horizontal)
        .onTapGesture {
            selectedMedia = item
        }
    }

    private func loadDailyCards() {
        let today = Calendar.current.startOfDay(for: Date())
        let mockDate = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 6))!

        let savedDate = UserDefaults.standard.object(forKey: "lastWellnessDate") as? Date
        let savedCardIDs = UserDefaults.standard.array(forKey: "dailyWellnessIDs") as? [String]

        if let savedDate = savedDate, Calendar.current.isDate(savedDate, inSameDayAs: mockDate), let ids = savedCardIDs {
            dailyCards = allCards.filter { ids.contains($0.id.uuidString) }
        } else {
            dailyCards = Array(allCards.shuffled().prefix(3))
            UserDefaults.standard.set(today, forKey: "lastWellnessDate")
            UserDefaults.standard.set(dailyCards.map { $0.id.uuidString }, forKey: "dailyWellnessIDs")
        }

        flippedStates = Dictionary(uniqueKeysWithValues: dailyCards.map { ($0.id, false) })
    }
}


struct AudioPlayerView: View {
    let resource: String
    @State private var player: AVAudioPlayer?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Now Playing")
                .font(.title2)
            Image(systemName: "music.note.list")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            Text(resource.replacingOccurrences(of: "_", with: " ").capitalized)
        }
        .onAppear {
            MusicPlayer.shared.stop()  // Ensure BGM is stopped here too
            if let url = Bundle.main.url(forResource: resource, withExtension: "mp3") {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.play()
                } catch {
                    print("Failed to play audio: \(error)")
                }
            }
        }

        .onDisappear {
            player?.stop()
            MusicPlayer.shared.playRandomTrack()  // Resume background music
        }

    }
}
