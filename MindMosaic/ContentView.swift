import SwiftUI



struct ContentView: View {
    
    var body: some View {
        
        TabView {
            MoodCheckInView()
                .tabItem {
                    Label("Check-In", systemImage: "square.and.pencil")
                }

            MindfulnessCenterView()
                .tabItem {
                    Label("Center", systemImage: "sparkles")
                }
            AIChatView()
                            .tabItem {
                                Label("Chat", systemImage: "bubble.left.and.bubble.right")
                            }

            MindfulMomentView()
                .tabItem {
                    Label("Breathe", systemImage: "wind")
                }
            SelfHelpBookView()
                .tabItem {
                    Label("Books", systemImage: "books.vertical.fill")
                }

            MoodHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            
            MoodGraphView()
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }
            
        }
    }
}

