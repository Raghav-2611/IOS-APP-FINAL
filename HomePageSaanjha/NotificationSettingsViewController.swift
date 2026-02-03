import UIKit

final class NotificationSettingsViewController: UITableViewController {

    // MARK: - Settings State
    private var medicationEnabled = true
    private var exerciseEnabled = true
    private var appointmentEnabled = true
    private var insightEnabled = true
    private var generalReminderTime: Date =
        Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    private var hideContentOnLock = false

    private var showTimePicker = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
        navigationController?.navigationBar.prefersLargeTitles = false

        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .saanjhaLightPink
    }

    // MARK: - Table Sections
    private enum Section: Int, CaseIterable {
        case reminders
        case timing
        case privacy
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .reminders: return 3
        case .timing: return showTimePicker ? 2 : 1
        case .privacy: return 1
        }
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch Section(rawValue: section)! {
        case .reminders: return "Reminder Categories"
        case .timing: return "Timing & Insights"
        case .privacy: return "Privacy"
        }
    }

    // MARK: - Cells
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let section = Section(rawValue: indexPath.section)!

        switch section {

        // -----------------------------
        case .reminders:
        // -----------------------------
            let cell = switchCell()

            if indexPath.row == 0 {
                configure(cell, title: "Medication / Supplements",
                          state: medicationEnabled) { self.medicationEnabled = $0 }
            } else if indexPath.row == 1 {
                configure(cell, title: "Exercise / Activity",
                          state: exerciseEnabled) { self.exerciseEnabled = $0 }
            } else {
                configure(cell, title: "Appointments",
                          state: appointmentEnabled) { self.appointmentEnabled = $0 }
            }
            return cell

        // -----------------------------
        case .timing:
        // -----------------------------
            if indexPath.row == 0 {
                let cell = switchCell()
                configure(cell, title: "Daily Pregnancy Insight",
                          state: insightEnabled) { self.insightEnabled = $0 }
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                let picker = UIDatePicker()
                picker.datePickerMode = .time
                picker.date = generalReminderTime
                picker.preferredDatePickerStyle = .wheels
                picker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)

                picker.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(picker)

                NSLayoutConstraint.activate([
                    picker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                    picker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                    picker.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    picker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                ])

                return cell
            }

        // -----------------------------
        case .privacy:
        // -----------------------------
            let cell = switchCell()
            configure(cell, title: "Hide Notification Content on Lock Screen",
                      state: hideContentOnLock) { self.hideContentOnLock = $0 }
            return cell
        }
    }

    // MARK: - Select Row (Expand date picker)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == Section.timing.rawValue &&
           indexPath.row == 0 {

            showTimePicker.toggle()
            tableView.reloadSections(
                IndexSet(integer: Section.timing.rawValue),
                with: .fade
            )
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Helpers
    private func switchCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .saanjhaLightPink
        return cell
    }

    private func configure(
        _ cell: UITableViewCell,
        title: String,
        state: Bool,
        onChange: @escaping (Bool) -> Void
    ) {
        cell.textLabel?.text = title

        let toggle = UISwitch()
        toggle.isOn = state
        toggle.onTintColor = .saanjhaSoftPink
        toggle.addAction(UIAction { _ in onChange(toggle.isOn) }, for: .valueChanged)

        cell.accessoryView = toggle
    }

    @objc private func timeChanged(_ sender: UIDatePicker) {
        generalReminderTime = sender.date
    }
}
