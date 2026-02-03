import Foundation

final class ScheduleStore {

    static let shared = ScheduleStore()

    private(set) var items: [ScheduleItem] = []

    private let storageKey = "saanjha_schedule_items"

    private init() {
        load()
    }

    func add(_ item: ScheduleItem) {
        items.append(item)
        save()
    }

    func update(_ item: ScheduleItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save()
        }
    }

    func remove(_ item: ScheduleItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func items(on date: Date) -> [ScheduleItem] {
        let cal = Calendar.current
        return items.filter { item in
            // 1. Check if the item starts on this exact day
            if cal.isDate(item.date, inSameDayAs: date) { return true }
            
            // 2. If the date is BEFORE the item was even created, don't show it
            guard date > item.date else { return false }
            
            // 3. Check repetition rules
            switch item.repeatRule {
            case .everyDay:
                return true
            case .everyWeek:
                // Matches if it's the same day of the week (e.g., every Tuesday)
                return cal.isDate(item.date, equalTo: date, toGranularity: .weekday)
            case .everyMonth:
                // Matches if it's the same day of the month (e.g., the 15th)
                return cal.dateComponents([.day], from: item.date).day == cal.dateComponents([.day], from: date).day
            case .none:
                return false
            }
        }
    }

    private func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([ScheduleItem].self, from: data) {
            items = decoded
        }
    }
}
