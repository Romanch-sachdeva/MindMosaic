import SwiftUI

// main page after login
// keep track of mood with emoji
struct MoodCheckInView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var selectedMood = "😊"
    @State private var note = ""
    @State private var randomAffirmation = ""

    //user mod emoji
    let moods = ["😄", "😊", "🙂", "😐", "😟", "😢", "😡", "😴", "😰", "😌", "🤯", "🥳", "😭", "😶‍🌫️"]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Daily Affirmation Section
                    VStack {
                        //Text("Daily Affirmation")
                            //.font(.title2)
                            //.padding(.top)
                        Text(randomAffirmation)
                            .font(.title3)
                            .italic()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Divider()
                        .padding(.horizontal)

                    // Mood Check-In Section
                    Text("How am I feeling today?")
                        .font(.title2)
                    
                    let columns = [GridItem(.adaptive(minimum: 50))]
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood)
                                .font(.largeTitle)
                                .padding(8)
                                .background(mood == selectedMood ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedMood = mood
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    TextField("What am I grateful for today...", text: $note)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Save Check-In") {
                        viewModel.addMood(mood: selectedMood, note: note)
                        selectedMood = "😊"
                        note = ""
                        fetchRandomAffirmation()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    Text("Streak: \(viewModel.streak) days")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .onAppear {
            fetchRandomAffirmation()
        }
    }
    
    //get quotes from zenquotes api
    func fetchRandomAffirmation() {
        guard let url = URL(string: "https://zenquotes.io/api/random") else {
            randomAffirmation = "Failed to load affirmation."
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let quote = try? JSONDecoder().decode([Quote].self, from: data).first {
                    DispatchQueue.main.async {
                        randomAffirmation = "\"\(quote.q)\"\n– \(quote.a)"
                    }
                } else {
                    DispatchQueue.main.async {
                        randomAffirmation = "Could not decode affirmation."
                    }
                }
            } else {
                DispatchQueue.main.async {
                    randomAffirmation = "Network error. Try again later."
                }
            }
        }.resume()
    }
}
