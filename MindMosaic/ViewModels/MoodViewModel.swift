import Foundation


// mood logic for adding and getting mood history and tracking
class MoodViewModel: ObservableObject {
    @Published var entries: [MoodEntry] = []
    @Published var streak: Int = 0
    private var username: String

    //private let fileName = "mood_history.json"
    // gets mood per user
    //earlier was same for all
    private var fileName: String {
        return "mood_history_\(username).json"
    }

    init(username: String) {
        self.username = username
        load()
        calculateStreak()
    }


    func addMood(mood: String, note: String) {
        let newEntry = MoodEntry(date: Date(), mood: mood, note: note)
        entries.append(newEntry)
        save()
        calculateStreak()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try data.write(to: url)
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }
    }

    //get mood from local
    private func load() {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url) {
            if let saved = try? JSONDecoder().decode([MoodEntry].self, from: data) {
                self.entries = saved
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    //for streak purpose
    // TODO: check with team if needs to be removed
    private func calculateStreak() {
        let calendar = Calendar.current
        var currentStreak = 0

        for i in stride(from: entries.count - 1, through: 0, by: -1) {
            let entryDate = calendar.startOfDay(for: entries[i].date)
            let expectedDate = calendar.date(byAdding: .day, value: -currentStreak, to: Date())!

            if calendar.isDate(entryDate, inSameDayAs: expectedDate) {
                currentStreak += 1
            } else {
                break
            }
        }

        self.streak = currentStreak
    }
}
