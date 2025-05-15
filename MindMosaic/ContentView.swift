import SwiftUI


//start content here
//tabs on page(s)
struct ContentView: View {
    
    var body: some View {
        
        TabView {
            //main mood emjoi check page
            MoodCheckInView()
                .tabItem {
                    Label("Check-In", systemImage: "square.and.pencil")
                }
            //mindfulness media page with soungs and video and yoga
            MindfulnessCenterView()
                .tabItem {
                    Label("Center", systemImage: "sparkles")
                }
            //chat with ai for help
            AIChatView()
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right")
                }
            //breateh in breathe out page
            MindfulMomentView()
                .tabItem {
                    Label("Breathe", systemImage: "wind")
                }
            //search for self healing books and meditate
            SelfHelpBookView()
                .tabItem {
                    Label("Books", systemImage: "books.vertical.fill")
                }
            //track mood history
            MoodHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            //mood graph page
            MoodGraphView()
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }
            
        }
    }
}

