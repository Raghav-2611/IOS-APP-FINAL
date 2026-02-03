import UIKit

class ProfilePartnerSyncViewController: UITableViewController {

    // MARK: - Stored State
    private var currentCode: String = "Saanjha-P45R3"
    private var partnerName: String = "John Doe"
    private var isConnected: Bool = true

    // MARK: - Section Enum
    private enum Section: Int, CaseIterable {
        case connection
        case syncCode
        case permissions
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Partner Sync"
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .saanjhaLightPink
        navigationController?.navigationBar.tintColor = .saanjhaSoftPink
    }

    // MARK: - Section Count
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    // MARK: - Rows per Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .connection:
            return isConnected ? 2 : 1   // status row + disconnect button
        case .syncCode:
            return 2   // description+code, button
        case .permissions:
            return 4   // fixed list
        }
    }

    // MARK: - Section Titles
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch Section(rawValue: section)! {
        case .connection: return "Current Partner Connection"
        case .syncCode: return "Generate Sync Code (One-Time Use)"
        case .permissions: return "Partner Permissions"
        }
    }

    // MARK: - Render Cells
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let section = Section(rawValue: indexPath.section)!

        switch section {

        // -------------------------------------------------
        // MARK: 1) Connection Status
        // -------------------------------------------------
        case .connection:

            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.backgroundColor = .saanjhaLightPink

                let heart = UIImageView(
                    image: UIImage(systemName: "heart.fill")?
                        .withTintColor(.saanjhaSoftPink, renderingMode: .alwaysOriginal)
                )
                heart.frame = CGRect(x: 15, y: 17, width: 20, height: 20)
                cell.contentView.addSubview(heart)

                cell.textLabel?.text =
                    isConnected ? "Connected with \(partnerName)" : "Not Connected"
                cell.textLabel?.textColor = isConnected ? .saanjhaDarker : .gray
                cell.textLabel?.frame.origin.x = 45

                return cell

            } else {
                // Disconnect button
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.backgroundColor = .saanjhaLightPink

                cell.textLabel?.text = "Disconnect Partner"
                cell.textLabel?.textColor = .red
                cell.imageView?.image =
                    UIImage(systemName: "xmark.circle.fill")?
                        .withTintColor(.red, renderingMode: .alwaysOriginal)

                return cell
            }

        // -------------------------------------------------
        // MARK: 2) Sync Code Section
        // -------------------------------------------------
        case .syncCode:

            if indexPath.row == 0 {
                // Code display cell
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.backgroundColor = .saanjhaLightPink
                cell.textLabel?.numberOfLines = 0

                let vStack = UIStackView()
                vStack.axis = .vertical
                vStack.spacing = 8
                vStack.translatesAutoresizingMaskIntoConstraints = false

                let descriptionLabel = UILabel()
                descriptionLabel.text =
                    "Share this code with your partner to grant access:"
                descriptionLabel.font = UIFont.systemFont(ofSize: 14)
                descriptionLabel.textColor = .saanjhaDarker.withAlphaComponent(0.7)

                let codeLabel = UILabel()
                codeLabel.text = currentCode
                codeLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
                codeLabel.textColor = .saanjhaSoftPink
                codeLabel.textAlignment = .center
                codeLabel.backgroundColor = .saanjhaSoftPink.withAlphaComponent(0.1)
                codeLabel.layer.cornerRadius = 8
                codeLabel.layer.masksToBounds = true
                codeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
                codeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true

                vStack.addArrangedSubview(descriptionLabel)
                vStack.addArrangedSubview(codeLabel)

                cell.contentView.addSubview(vStack)
                NSLayoutConstraint.activate([
                    vStack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                    vStack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                    vStack.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                    vStack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
                ])

                return cell

            } else {
                // Button: Generate New Code
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.backgroundColor = .saanjhaLightPink

                cell.textLabel?.text = "Generate New Code"
                cell.textLabel?.textColor = .saanjhaSoftPink

                return cell
            }

        // -------------------------------------------------
        // MARK: 3) Permissions Summary
        // -------------------------------------------------
        case .permissions:

            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.backgroundColor = .saanjhaLightPink

            let permission = permissionData[indexPath.row]

            cell.textLabel?.text = permission.feature
            cell.detailTextLabel?.text = permission.access
            cell.detailTextLabel?.textColor =
                permission.isEditable ? .saanjhaSoftPink : .gray

            cell.imageView?.image =
                UIImage(systemName: permission.icon)?
                    .withTintColor(
                        permission.isEditable ? .saanjhaSoftPink : .saanjhaDarker,
                        renderingMode: .alwaysOriginal
                    )

            return cell
        }
    }

    // MARK: - Selection Handling
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = Section(rawValue: indexPath.section)!

        switch section {

        case .connection:
            if indexPath.row == 1 {
                isConnected = false   // disconnect
                tableView.reloadSections(IndexSet(integer: Section.connection.rawValue), with: .fade)
            }

        case .syncCode:
            if indexPath.row == 1 {
                currentCode = generateNewCode()
                tableView.reloadSections(IndexSet(integer: Section.syncCode.rawValue), with: .fade)
            }

        case .permissions:
            break
        }
    }

    // MARK: - Permission Data
    private struct Permission {
        let feature: String
        let access: String
        let icon: String
        let isEditable: Bool
    }

    private let permissionData: [Permission] = [
        Permission(feature: "Tracking & Stats", access: "Read Only", icon: "chart.bar.fill", isEditable: false),
        Permission(feature: "Medical Vault", access: "Edit Access", icon: "cross.case.fill", isEditable: true),
        Permission(feature: "Schedule & Calendar", access: "Edit Access", icon: "calendar.badge.clock", isEditable: true),
        Permission(feature: "Insights & Advice", access: "Read Only", icon: "lightbulb.fill", isEditable: false)
    ]

    // MARK: - Code Generator
    private func generateNewCode() -> String {
        let chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let random = String((0..<6).map { _ in chars.randomElement()! })
        return "Saanjha-" + random
    }
}
