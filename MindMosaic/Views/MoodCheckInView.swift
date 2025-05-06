import SwiftUI

struct MoodCheckInView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var selectedMood = "😊"
    @State private var note = ""
    @State private var randomAffirmation = ""

    let moods = ["😄", "😊", "🙂", "😐", "😟", "😢", "😡", "😴", "😰", "😌", "🤯", "🥳", "😭", "😶‍🌫️"]

    let affirmations = [
        "You are enough.",
        "Take it one step at a time.",
        "Breathe. You’re doing your best.",
        "Your feelings are valid.",
        "Today is a new beginning.",
        "Let go of what you can't control.",
        "I am worthy of love and belonging.",
        "I am capable of handling whatever comes my way.",
        "I choose peace and calm in this moment.",
        "I am strong, resilient, and courageous.",
        "I trust my intuition and inner wisdom.",
        "I am open to receiving joy and abundance.",
        "I embrace challenges as opportunities for growth.",
        "I am kind to myself and others.",
        "I forgive myself for past mistakes.",
        "I am making progress every day.",
        "I am grateful for all the good in my life.",
        "I radiate positivity and attract positive experiences.",
        "I am in control of my thoughts and feelings.",
        "I am enough, just as I am.",
        "I believe in my ability to succeed.",
        "I am present and appreciate this moment.",
        "I nurture my mind, body, and spirit.",
        "I am surrounded by love and support.",
        "I create a life I love.",
        "Today is a new and wonderful beginning."
    ]

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
                        randomAffirmation = affirmations.randomElement() ?? ""
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
            randomAffirmation = affirmations.randomElement() ?? ""
        }
    }
}
