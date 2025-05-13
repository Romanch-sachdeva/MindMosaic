import SwiftUI

@main
struct MindMosaicApp: App {
    @StateObject private var userManager = UserManager()
    //@StateObject private var moodViewModel = MoodViewModel()
    @State private var moodViewModel: MoodViewModel? = nil

    var body: some Scene {
        WindowGroup {
            if let user = userManager.loggedInUser {
                if let viewModel = moodViewModel {
                    ContentView()
                        .environmentObject(userManager)
                        .environmentObject(viewModel)
                } else {
                    Color.clear
                        .onAppear {
                            moodViewModel = MoodViewModel(username: user.username)
                        }
                }
            } else {
                LoginView()
                    .environmentObject(userManager)
                    .onAppear {
                        MusicPlayer.shared.playRandomTrack()
                    }
            }
        }
    }

}
