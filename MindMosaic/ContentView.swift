import SwiftUI



struct ContentView: View {
    
    var body: some View {
        
        TabView {
            MoodCheckInView()
                .tabItem {
                    Label("Check-In", systemImage: "square.and.pencil")
                }

            MoodHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            MindfulnessCenterView()
                .tabItem {
                    Label("Center", systemImage: "sparkles")
                }

            MindfulMomentView()
                .tabItem {
                    Label("Breathe", systemImage: "wind")
                }
            
            MoodGraphView()
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }
            SelfHelpBookView()
                .tabItem {
                    Label("Books", systemImage: "books.vertical.fill")
                }

        }
    }
}

