import UIKit

final class ScheduleViewController: UIViewController {

    // MARK: - UI Components
    private let calendarContainer = UIView()
    private let calendarView = UICalendarView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let todayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Today", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .saanjhaSoftPink
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 14
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        return button
    }()

    // MARK: - Data State
    private var eventsForSelectedDate: [ScheduleItem] = []
    private var tasksForSelectedDate: [ScheduleItem] = []
    private var selectedDateComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    private var selectedDate: Date {
        Calendar.current.date(from: selectedDateComponents) ?? Date()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. Consistency: Entire background is now Saanjha Light Pink
        view.backgroundColor = .saanjhaLightPink
        
        setupNavigation()
        setupCalendar()
        setupTable()
        loadSampleItemsIfNeeded()
        reloadForSelectedDate()
    }

    // MARK: - Setup Logic
    private func setupNavigation() {
        navigationItem.title = "Our Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Theme color for navigation
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .saanjhaLightPink
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.saanjhaDarker]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.saanjhaDarker]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .saanjhaSoftPink

        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(addItemTapped)
        )
        navigationItem.rightBarButtonItem = addButton

        todayButton.addTarget(self, action: #selector(todayTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: todayButton)
    }
    private func loadSampleItemsIfNeeded() {
            // Prevent reloading samples if the store already has data
            guard ScheduleStore.shared.items.isEmpty else { return }

            let cal = Calendar.current
            let now = Date()

            // Create sample dates for tomorrow and next week
            if let tomorrow = cal.date(byAdding: .day, value: 1, to: now),
               let nextWeek = cal.date(byAdding: .day, value: 7, to: now) {

                let scan = ScheduleItem(
                    title: "First trimester scan",
                    date: cal.date(bySettingHour: 10, minute: 0, second: 0, of: tomorrow) ?? tomorrow,
                    notes: "City Hospital – go together",
                    kind: .event
                )

                let vitamins = ScheduleItem(
                    title: "Prenatal vitamins",
                    date: cal.date(bySettingHour: 9, minute: 0, second: 0, of: now) ?? now,
                    notes: "Partner checks if taken",
                    kind: .task
                )

                let yoga = ScheduleItem(
                    title: "Light evening walk",
                    date: cal.date(bySettingHour: 18, minute: 30, second: 0, of: nextWeek) ?? nextWeek,
                    notes: "Short walk together",
                    kind: .task
                )

                // Add samples to the shared store
                ScheduleStore.shared.add(scan)
                ScheduleStore.shared.add(vitamins)
                ScheduleStore.shared.add(yoga)
            }
        }
    private func setupCalendar() {
        calendarContainer.layer.cornerRadius = 24
        calendarContainer.backgroundColor = .white
        calendarContainer.layer.shadowColor = UIColor.black.cgColor
        calendarContainer.layer.shadowOpacity = 0.05
        calendarContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        calendarContainer.layer.shadowRadius = 15

        view.addSubview(calendarContainer)
        calendarContainer.translatesAutoresizingMaskIntoConstraints = false

        calendarView.calendar = Calendar.current
        calendarView.locale = Locale.current
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = .clear
        calendarView.delegate = self
        
        // 2. Theme Adjustment: Replacing system blue with Saanjha Soft Pink
        calendarView.tintColor = .saanjhaSoftPink
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        selection.setSelected(selectedDateComponents, animated: false)
        calendarView.selectionBehavior = selection

        calendarContainer.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            calendarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            calendarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            calendarView.topAnchor.constraint(equalTo: calendarContainer.topAnchor, constant: 8),
            calendarView.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor, constant: 8),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainer.trailingAnchor, constant: -8),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainer.bottomAnchor, constant: -8),
            calendarView.heightAnchor.constraint(equalToConstant: 380)
        ])
    }

    private func setupTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendarContainer.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func reloadForSelectedDate() {
        let dayItems = ScheduleStore.shared.items(on: selectedDate)
        eventsForSelectedDate = dayItems.filter { $0.kind == .event }.sorted { $0.date < $1.date }
        tasksForSelectedDate = dayItems.filter { $0.kind == .task }.sorted { $0.date < $1.date }
        
        // Modern interaction: Animate the table reload
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        })
        
        calendarView.reloadDecorations(forDateComponents: [selectedDateComponents], animated: true)
    }

    // MARK: - Actions
    @objc private func addItemTapped() {
        let addVC = AddScheduleItemViewController(selectedDate: selectedDate) { [weak self] newItem in
            ScheduleStore.shared.add(newItem)
            self?.reloadForSelectedDate()
        }
        present(UINavigationController(rootViewController: addVC), animated: true)
    }

    @objc private func todayTapped() {
        selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        (calendarView.selectionBehavior as? UICalendarSelectionSingleDate)?.setSelected(selectedDateComponents, animated: true)
        reloadForSelectedDate()
    }
}

// MARK: - UITableView Handlers
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource

    // MARK: - UITableViewDataSource logic

    func numberOfSections(in tableView: UITableView) -> Int {
        // We always want 2 sections: Section 0 for Appointments (Events), Section 1 for Daily Tasks
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Section 0 pulls from events, Section 1 pulls from tasks
        return section == 0 ? eventsForSelectedDate.count : tasksForSelectedDate.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Only show a header if the section actually has items to display
        let hasItems = section == 0 ? !eventsForSelectedDate.isEmpty : !tasksForSelectedDate.isEmpty
        guard hasItems else { return nil }

        let headerView = UIView()
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .saanjhaDarker
        
        // Set the specific heading based on the section index
        label.text = (section == 0) ? "Events" : " Tasks"
        
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // If the section is empty, set height to 0 to hide the gap
        let hasItems = section == 0 ? !eventsForSelectedDate.isEmpty : !tasksForSelectedDate.isEmpty
        return hasItems ? 40 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as! ScheduleCell
        
        // Select the correct item based on the section
        let item = (indexPath.section == 0) ? eventsForSelectedDate[indexPath.row] : tasksForSelectedDate[indexPath.row]
        
        cell.configure(with: item)
        return cell
    }
    
   
}

// MARK: - UICalendarView Logic (Interactive & Live)
extension ScheduleViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let comps = dateComponents else { return }
        selectedDateComponents = comps
        reloadForSelectedDate()
        
        // Haptic feedback for a modern feel
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let date = Calendar.current.date(from: dateComponents) else { return nil }
        let items = ScheduleStore.shared.items(on: date)
        
        if items.isEmpty { return nil }
        
        let hasEvent = items.contains { $0.kind == .event }
        let hasTask = items.contains { $0.kind == .task }
        
        // 3. Easy Understanding: Multi-color decorations
        if hasEvent && hasTask {
            // Mixed day: Custom view with two dots
            return .customView {
                let stack = UIStackView()
                stack.spacing = 2
                let dot1 = UIView(); dot1.backgroundColor = .saanjhaSoftPink; dot1.layer.cornerRadius = 3
                let dot2 = UIView(); dot2.backgroundColor = .systemTeal; dot2.layer.cornerRadius = 3
                [dot1, dot2].forEach {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.widthAnchor.constraint(equalToConstant: 6).isActive = true
                    $0.heightAnchor.constraint(equalToConstant: 6).isActive = true
                    stack.addArrangedSubview($0)
                }
                return stack
            }
        } else if hasEvent {
            return .default(color: .saanjhaSoftPink, size: .medium)
        } else {
            return .default(color: .systemTeal, size: .medium)
        }
    }
}
