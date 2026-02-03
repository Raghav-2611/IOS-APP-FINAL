import UIKit

// MARK: - Global Data Models
struct TrackerItem: Hashable {
    let id: String
    let name: String
    let imageAsset: String
    let accentColor: UIColor
    let unit: String
    let description: String
    let type: TrackerType
    let isEnabled: Bool

    enum TrackerType {
        case counter
        case numericInput
        case selection
        case photoGallery
    }
}

struct TrackerData {
    var stat: String
    var status: String
}

// MARK: - Mood Model
enum Mood: String, CaseIterable {
    case peaceful = "Peaceful 🧘‍♀️"
    case energetic = "Energetic ⚡️"
    case content   = "Content 😊"
    case tired     = "Tired 😴"
    case anxious   = "Anxious 😟"
    case nauseous  = "Nauseous 🤢"
}
