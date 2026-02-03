//
//  VaultReportDetailViewController.swift
//

import UIKit

final class VaultReportDetailViewController: UIViewController {

    private let report: VaultReport

    init(report: VaultReport) {
        self.report = report
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = report.title

        let label = UILabel()
        label.text = "Type: \(report.reportType)\nDate: \(formatted(report.reportDate))"
        label.numberOfLines = 0
        label.frame = view.bounds.insetBy(dx: 20, dy: 20)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(label)
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
