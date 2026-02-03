import UIKit

final class AddScheduleItemViewController: UITableViewController, UITextViewDelegate {

    private let baseDate: Date
    private let onSave: (ScheduleItem) -> Void

    private let titleField = UITextField()
    private let notesTextView = UITextView()
    private let datePicker = UIDatePicker()
    private let kindSegment = UISegmentedControl(items: ["Event", "Task"])
    private let repeatSegment = UISegmentedControl(items: ["None","Daily","Weekly","Monthly"])

    private var notesPlaceholder = "Notes (optional)"

    init(selectedDate: Date, onSave: @escaping (ScheduleItem) -> Void) {
        self.baseDate = selectedDate
        self.onSave = onSave
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "New schedule item"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        navigationController?.navigationBar.tintColor = .saanjhaSoftPink

        tableView.backgroundColor = .systemBackground

        setupFields()
    }

    private func setupFields() {
        titleField.placeholder = "Title (e.g. Prenatal vitamins)"
        titleField.font = UIFont.preferredFont(forTextStyle: .body)
        titleField.adjustsFontForContentSizeCategory = true

        notesTextView.font = UIFont.preferredFont(forTextStyle: .body)
        notesTextView.adjustsFontForContentSizeCategory = true
        notesTextView.textColor = .secondaryLabel
        notesTextView.text = notesPlaceholder
        notesTextView.isScrollEnabled = false
        notesTextView.delegate = self

        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = baseDate
        datePicker.minuteInterval = 5

        kindSegment.selectedSegmentIndex = 0
        repeatSegment.selectedSegmentIndex = 0
    }

    // MARK: - Table data

    override func numberOfSections(in tableView: UITableView) -> Int {
        3 // details, time, repeat/type
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2   // title + notes
        case 1: return 1   // time
        case 2: return 2   // type + repeat
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Details"
        case 1: return "Time"
        case 2: return "Type & repeat"
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.contentView.addSubview(titleField)
            titleField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                titleField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                titleField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                titleField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
            ])

        case (0, 1):
            cell.contentView.addSubview(notesTextView)
            notesTextView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                notesTextView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4),
                notesTextView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4),
                notesTextView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 12),
                notesTextView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
                notesTextView.heightAnchor.constraint(equalToConstant: 90)
            ])

        case (1, 0):
            cell.textLabel?.text = "Time"
            cell.accessoryView = datePicker

        case (2, 0):
            cell.textLabel?.text = "Kind"
            cell.selectionStyle = .none
            cell.contentView.addSubview(kindSegment)
            kindSegment.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                kindSegment.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                kindSegment.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
            ])

        case (2, 1):
            cell.textLabel?.text = "Repeat"
            cell.selectionStyle = .none
            cell.contentView.addSubview(repeatSegment)
            repeatSegment.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                repeatSegment.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                repeatSegment.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
            ])

        default:
            break
        }

        return cell
    }

    // MARK: - UITextViewDelegate

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == notesPlaceholder {
            textView.text = nil
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            textView.text = notesPlaceholder
            textView.textColor = .secondaryLabel
        }
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        guard let titleText = titleField.text,
              !titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }

        var components = Calendar.current.dateComponents([.year, .month, .day], from: baseDate)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute

        let finalDate = Calendar.current.date(from: components) ?? baseDate
        let kind: ScheduleItemKind = kindSegment.selectedSegmentIndex == 0 ? .event : .task

        let repeatRule: RepeatRule
        switch repeatSegment.selectedSegmentIndex {
        case 1: repeatRule = .everyDay
        case 2: repeatRule = .everyWeek
        case 3: repeatRule = .everyMonth
        default: repeatRule = .none
        }

        let notes = notesTextView.text == notesPlaceholder ? nil : notesTextView.text

        let newItem = ScheduleItem(
            title: titleText,
            date: finalDate,
            notes: notes,
            kind: kind,
            createdByName: nil,
            repeatRule: repeatRule
        )

        onSave(newItem)
        dismiss(animated: true)
    }
}
