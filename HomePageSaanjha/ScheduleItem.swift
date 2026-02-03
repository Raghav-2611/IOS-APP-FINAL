import Foundation

enum ScheduleItemKind: String, Codable {
    case event
    case task
}

enum RepeatRule: String, Codable {
    case none
    case everyDay
    case everyWeek
    case everyMonth
}

struct ScheduleItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var notes: String?
    var kind: ScheduleItemKind
    var createdByName: String?
    var repeatRule: RepeatRule

    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        notes: String?,
        kind: ScheduleItemKind,
        createdByName: String? = nil,
        repeatRule: RepeatRule = .none
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.notes = notes
        self.kind = kind
        self.createdByName = createdByName
        self.repeatRule = repeatRule
    }
}
