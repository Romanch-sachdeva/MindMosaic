//
//  MoodHistoryView.swift
//  MindMosaic



import SwiftUI


//only shows history per day and in list
struct MoodHistoryView: View {
    
    @EnvironmentObject var viewModel: MoodViewModel

    var body: some View {
        
            VStack{
                List(viewModel.entries.reversed()) { entry in
                    VStack(alignment: .leading) {
                        Text("\(entry.mood) \(entry.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.headline)
                        if !entry.note.isEmpty {
                            Text(entry.note)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Mood History")
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        
        
    }
        
}
