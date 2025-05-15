//
//  MoodGraphView.swift
//  MindMosaic



import SwiftUI
import Charts

// shows mood histry in chart over time
struct MoodGraphView: View {
    
    @EnvironmentObject var viewModel: MoodViewModel

    var dailyAverages: [MoodStat] {
        let grouped = Dictionary(grouping: viewModel.entries) {
            Calendar.current.startOfDay(for: $0.date)
        }

        // each mapped to mood stat and avg but also ignores date(day)
        return grouped.map { (date, entries) in
            let average = entries.map { moodScore(from: $0.mood) }.reduce(0, +) / Double(entries.count)
            return MoodStat(date: date, averageScore: average)
        }
        .sorted { $0.date < $1.date }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("My Mood Wellbeing Over Time")
                    .font(.title2)
                    .padding()
                
                Chart {
                    ForEach(dailyAverages) { stat in
                        LineMark(
                            x: .value("Date", stat.date),
                            y: .value("Mood Score", stat.averageScore)
                        )
                        .symbol(Circle())
                    }
                }
                .frame(height: 250)
                .padding()
            }
        }
    }

    //emoji to number for scoring
    private func moodScore(from mood: String) -> Double {
        switch mood {
        case "🥳": return 5
        case "😄": return 4.5
        case "😊": return 4.25
        case "🙂": return 4
        case "😌": return 3.5
        case "😐": return 3
        case "😴": return 2.75
        case "😟": return 2.5
        case "😰": return 2
        case "😢", "😡": return 1.5
        case "😭", "🤯", "😶‍🌫️": return 1
        default: return 3
        }
    }

}

//for avg mood
struct MoodStat: Identifiable {
    var id: Date { date }
    let date: Date
    let averageScore: Double
}
