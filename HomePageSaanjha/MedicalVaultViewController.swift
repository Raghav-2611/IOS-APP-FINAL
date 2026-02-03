//
//  MedicalVaultViewController.swift
//

import UIKit
import SwiftData

final class MedicalVaultViewController: UIViewController,
                                        UITableViewDataSource,
                                        UITableViewDelegate {

    private var modelContext: ModelContext!
    private var reports: [VaultReport] = []

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Medical Vault"
        view.backgroundColor = .saanjhaLightPink
        navigationController?.navigationBar.prefersLargeTitles = true

        setupModelContext()
        setupTableView()
        setupAddButton()
        fetchReports()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReports()
        tableView.reloadData()
    }

    // MARK: - Use shared ModelContainer from SceneDelegate
    private func setupModelContext() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = scene.delegate as? SceneDelegate,
           let container = delegate.modelContainer {

            self.modelContext = container.mainContext
            return
        }

        fatalError("❌ No shared ModelContainer found")
    }

    private func fetchReports() {
        let descriptor = FetchDescriptor<VaultReport>(sortBy: [
            .init(\.reportDate, order: .reverse)
        ])

        if let list = try? modelContext.fetch(descriptor) {
            reports = list
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReportCell")
    }

    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(addReportTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .saanjhaSoftPink
    }

    @objc private func addReportTapped() {
        let addVC = VaultAddReportViewController(context: modelContext)
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }

    // MARK: Table DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        reports.isEmpty ? 0 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reports.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let report = reports[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)

        cell.textLabel?.text = report.title
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(systemName: "doc.text.fill")?.withTintColor(.saanjhaSoftPink, renderingMode: .alwaysOriginal)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = reports[indexPath.row]
        navigationController?.pushViewController(VaultReportDetailViewController(report: report), animated: true)
    }
}
