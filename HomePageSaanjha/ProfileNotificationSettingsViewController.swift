//
//  ProfileNotificationSettingsView.swift
//  HomePageSaanjha
//
//  Created by user@99 on 25/11/25.
//
import UIKit

class ProfileNotificationSettingsViewController: UITableViewController {

    // MARK: - Stored Settings
    private var medicationEnabled = true
    private var exerciseEnabled = true
    private var appointmentEnabled = true
    private var insightEnabled = true
    private var hideContentOnLockScreen = false

    private var generalReminderTime: Date =
        Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!

    private var showGeneralTimePicker = false

    // MARK: - Section Index
    private enum Section: Int, CaseIterable {
        case reminders
        case timing
        case privacy
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .saanjhaLightPink

        navigationController?.navigationBar.tintColor = .saanjhaSoftPink
    }

    // MARK: - Table Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .reminders: return 3
        case .timing: return showGeneralTimePicker ? 2 : 1
        case .privacy: return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .reminders: return "Reminder Categories"
        case .timing: return "Timing & Insights"
        case .privacy: return "Privacy"
        }
    }

    // MARK: - Render Cells
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let section = Section(rawValue: indexPath.section)!

        switch section {

        // -------------------------------
        // MARK: Reminder Toggles
        // -------------------------------
        case .reminders:

            let cell = createSwitchCell()

            switch indexPath.row {
            case 0:
                configureSwitchCell(
                    cell,
                    title: "Medication / Supplements",
                    isOn: medicationEnabled
                ) { self.medicationEnabled = $0 }

            case 1:
                configureSwitchCell(
                    cell,
                    title: "Exercise / Activity",
                    isOn: exerciseEnabled
                ) { self.exerciseEnabled = $0 }

            case 2:
                configureSwitchCell(
                    cell,
                    title: "Appointments",
                    isOn: appointmentEnabled
                ) { self.appointmentEnabled = $0 }

            default: break
            }
            return cell

        // -------------------------------
        // MARK: Timing & Insights
        // -------------------------------
        case .timing:

            if indexPath.row == 0 {
                // Toggle: Daily Insight
                let cell = createSwitchCell()
                configureSwitchCell(
                    cell,
                    title: "Daily Pregnancy Insight",
                    isOn: insightEnabled
                ) { self.insightEnabled = $0 }
                return cell
            } else {
                // Date Picker Cell
                let cell = UITableViewCell()
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .time
                datePicker.date = generalReminderTime
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.addTarget(self, action: #selector(didChangeDailyTime(_:)), for: .valueChanged)
                datePicker.tintColor = .saanjhaSoftPink

                cell.contentView.addSubview(datePicker)
                datePicker.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    datePicker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                    datePicker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                    datePicker.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    datePicker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                ])
                return cell
            }

        // -------------------------------
        // MARK: Privacy
        // -------------------------------
        case .privacy:

            let cell = createSwitchCell()
            configureSwitchCell(
                cell,
                title: "Hide Notification Content on Lock Screen",
                isOn: hideContentOnLockScreen
            ) { self.hideContentOnLockScreen = $0 }

            return cell
        }
    }

    // MARK: - Row Selection Handling
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == Section.timing.rawValue &&
            indexPath.row == 0 {

            showGeneralTimePicker.toggle()
            tableView.reloadSections(IndexSet(integer: Section.timing.rawValue), with: .fade)
        }
    }

    // MARK: - Helper: Switch Cell Factory
    private func createSwitchCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .saanjhaLightPink
        return cell
    }

    private func configureSwitchCell(
        _ cell: UITableViewCell,
        title: String,
        isOn: Bool,
        onChange: @escaping (Bool) -> Void
    ) {
        cell.textLabel?.text = title

        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.onTintColor = .saanjhaSoftPink

        toggle.addAction(UIAction(handler: { _ in
            onChange(toggle.isOn)
        }), for: .valueChanged)

        cell.accessoryView = toggle
    }

    // MARK: - Daily Time Picker Change
    @objc private func didChangeDailyTime(_ sender: UIDatePicker) {
        generalReminderTime = sender.date
    }
}
