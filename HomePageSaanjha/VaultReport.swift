//
//  VaultReport.swift
//

import SwiftData
import Foundation

@Model
final class VaultReport {

    @Attribute(.unique)
    var id: UUID = UUID()

    var title: String
    var reportType: String
    var reportDate: Date
    var imageIdentifiers: [String]
    var uploadDate: Date

    init(
        title: String = "",
        reportType: String = "General",
        reportDate: Date = Date(),
        imageIdentifiers: [String] = [],
        uploadDate: Date = Date()
    ) {
        self.title = title
        self.reportType = reportType
        self.reportDate = reportDate
        self.imageIdentifiers = imageIdentifiers
        self.uploadDate = uploadDate
    }
}
