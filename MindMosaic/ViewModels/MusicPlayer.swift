//
//  MusicPlayer.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 4/5/2025.
//


import AVFoundation

class MusicPlayer: ObservableObject {
    static let shared = MusicPlayer()
    var player: AVAudioPlayer?

    let tracks = ["calm1", "calm2", "calm3", "calm4", "calm5", "calm6", "calm7"]

    private init() {}

    func playRandomTrack() {
        stop()
        guard let track = tracks.randomElement(),
              let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Track not found.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // loop indefinitely
            player?.play()
        } catch {
            print("Failed to play music: \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
    }
}
