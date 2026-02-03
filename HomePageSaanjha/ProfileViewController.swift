import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Scroll + Layout
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainStackView = UIStackView()

    // MARK: - Header Elements (Refreshable)
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dueDateLabel = UILabel()
    private let ageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .saanjhaLightPink
        title = "My Profile"

        setupViews()
        addPersonalInfoHeader()
        addSettingsOptions()
        styleNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true

        // ⭐ CRITICAL REFRESH
        refreshProfileData()
    }

    // MARK: - Navigation Bar Styling
    private func styleNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = true
            navBar.tintColor = .saanjhaSoftPink
            navBar.titleTextAttributes = [.foregroundColor: UIColor.saanjhaDarker]
            navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.saanjhaDarker]
        }
    }

    // MARK: - Setup Views
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        mainStackView.axis = .vertical
        mainStackView.spacing = 30

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Header Section
    private func addPersonalInfoHeader() {

        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 16
        headerStack.alignment = .center

        // Profile Image
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .saanjhaSoftPink
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])

        // Labels
        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.spacing = 4

        nameLabel.text = "Jane Doe"
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .saanjhaDarker

        dueDateLabel.text = "Due Date: --"
        dueDateLabel.font = .systemFont(ofSize: 16)
        dueDateLabel.textColor = .saanjhaDarker.withAlphaComponent(0.8)

        ageLabel.text = "Age: -- | Location: --"
        ageLabel.font = .systemFont(ofSize: 16)
        ageLabel.textColor = .saanjhaDarker.withAlphaComponent(0.8)

        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(dueDateLabel)
        infoStack.addArrangedSubview(ageLabel)

        headerStack.addArrangedSubview(profileImageView)
        headerStack.addArrangedSubview(infoStack)

        mainStackView.addArrangedSubview(headerStack)
        mainStackView.addArrangedSubview(createSeparator(fullWidth: true))
    }

    // MARK: - Refresh Data
    private func refreshProfileData() {
        let defaults = UserDefaults.standard

        let storedName = defaults.string(forKey: "userName") ?? "Jane Doe"
        let storedAge = defaults.integer(forKey: "userAge")
        let storedLocation = defaults.string(forKey: "userLocation") ?? "Unknown"
        let storedLMPDate = defaults.object(forKey: "userLMPDate") as? Date

        // Calculate due date
        if let lmp = storedLMPDate {
            let due = calculateDueDate(from: lmp)
            let f = DateFormatter()
            f.dateStyle = .medium
            dueDateLabel.text = "Due Date: \(f.string(from: due))"
        } else {
            dueDateLabel.text = "Due Date: N/A"
        }

        nameLabel.text = storedName
        ageLabel.text = "Age: \(storedAge) | Location: \(storedLocation)"

        loadProfileImageFromDisk()
    }

    // MARK: - Image Loader
    private func loadProfileImageFromDisk() {
        let filename = "profile_image.jpeg"
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let path = dir.appendingPathComponent(filename)

        if let data = try? Data(contentsOf: path),
           let img = UIImage(data: data) {
            profileImageView.image = img
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.clipsToBounds = true
            profileImageView.tintColor = nil
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .saanjhaSoftPink
            profileImageView.contentMode = .scaleAspectFit
        }
    }

    private func calculateDueDate(from lmp: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: 280, to: lmp) ?? lmp
    }

    // MARK: - Settings Section
    private func addSettingsOptions() {

        func makeSectionHeader(_ text: String) {
            let label = UILabel()
            label.text = text.uppercased()
            label.font = .systemFont(ofSize: 13, weight: .bold)
            label.textColor = .saanjhaSoftPink

            let wrapper = UIView()
            wrapper.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 10),
                label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 16),
                label.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -5)
            ])

            mainStackView.addArrangedSubview(wrapper)
        }

        // MARK: ACCOUNT
        makeSectionHeader("Account")

        let accountGroup = UIStackView()
        accountGroup.axis = .vertical
        accountGroup.layer.cornerRadius = 12
        accountGroup.clipsToBounds = true

        accountGroup.addArrangedSubview(createListButton(
            title: "Edit Personal Details",
            iconName: "person.crop.circle",
            action: #selector(editInfoTapped),
            addSeparator: true
        ))

        accountGroup.addArrangedSubview(createListButton(
            title: "Account & Security",
            iconName: "lock.fill",
            action: #selector(accountSecurityTapped),
            addSeparator: false
        ))

        mainStackView.addArrangedSubview(accountGroup)

        // MARK: MEDICAL
        makeSectionHeader("Medical & Data")

        let medicalGroup = UIStackView()
        medicalGroup.axis = .vertical
        medicalGroup.layer.cornerRadius = 12
        medicalGroup.clipsToBounds = true

        medicalGroup.addArrangedSubview(createListButton(
            title: "Medical Vault",
            iconName: "cross.case.fill",
            action: #selector(openMedicalVault),
            addSeparator: true
        ))

        medicalGroup.addArrangedSubview(createListButton(
            title: "Data Export & Reports",
            iconName: "doc.on.clipboard.fill",
            action: #selector(exportDataTapped),
            addSeparator: false
        ))

        mainStackView.addArrangedSubview(medicalGroup)

        // MARK: PREFERENCES
        makeSectionHeader("Preferences")

        let prefGroup = UIStackView()
        prefGroup.axis = .vertical
        prefGroup.layer.cornerRadius = 12
        prefGroup.clipsToBounds = true

        prefGroup.addArrangedSubview(createListButton(
            title: "Partner Sync & Code",
            iconName: "person.2.fill",
            action: #selector(partnerSyncTapped),
            addSeparator: true
        ))

        prefGroup.addArrangedSubview(createListButton(
            title: "Notification Settings",
            iconName: "bell.badge.fill",
            action: #selector(notificationSettingsTapped),
            addSeparator: false
        ))

        mainStackView.addArrangedSubview(prefGroup)

        // MARK: SUPPORT
        makeSectionHeader("Support")

        let supportGroup = UIStackView()
        supportGroup.axis = .vertical
        supportGroup.layer.cornerRadius = 12
        supportGroup.clipsToBounds = true

        supportGroup.addArrangedSubview(createListButton(
            title: "Help Center & FAQ",
            iconName: "questionmark.circle.fill",
            action: #selector(helpCenterTapped),
            addSeparator: true
        ))

        supportGroup.addArrangedSubview(createListButton(
            title: "Legal (TOS & Privacy)",
            iconName: "scroll.fill",
            action: #selector(legalTapped),
            addSeparator: true
        ))

        supportGroup.addArrangedSubview(createListButton(
            title: "Log Out",
            iconName: "arrow.right.square.fill",
            action: #selector(logOutTapped),
            color: .systemRed,
            addSeparator: false
        ))

        mainStackView.addArrangedSubview(supportGroup)
    }

    // MARK: - Create List Button Rows
    private func createListButton(title: String,
                                  iconName: String,
                                  action: Selector,
                                  color: UIColor = .saanjhaDarker,
                                  addSeparator: Bool) -> UIView {

        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: iconName)
        config.imagePadding = 15
        config.baseForegroundColor = color
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)

        let container = UIView()
        container.addSubview(button)
        container.translatesAutoresizingMaskIntoConstraints = false

        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 54),
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.topAnchor.constraint(equalTo: container.topAnchor),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .systemGray3
        arrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(arrow)

        NSLayoutConstraint.activate([
            arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        if addSeparator {
            let sep = createSeparator()
            container.addSubview(sep)
            sep.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                sep.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                sep.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                sep.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                sep.heightAnchor.constraint(equalToConstant: 0.6)
            ])
        }

        button.addTarget(self, action: action, for: .touchUpInside)
        return container
    }

    // MARK: - Navigation Actions
    @objc private func editInfoTapped() {
        navigationController?.pushViewController(ProfileEditPersonalInfoViewController(), animated: true)
    }

    @objc private func partnerSyncTapped() {
        navigationController?.pushViewController(ProfilePartnerSyncViewController(), animated: true)
    }

    @objc private func notificationSettingsTapped() {
        navigationController?.pushViewController(NotificationSettingsViewController(), animated: true)
    }

    @objc private func accountSecurityTapped() { print("Account & Security") }
    @objc private func exportDataTapped() { print("Export Data") }
    @objc private func helpCenterTapped() { print("Help Center") }
    @objc private func legalTapped() { print("Legal Page") }
    @objc private func logOutTapped() { print("Logged Out") }

    @objc private func openMedicalVault() {
        navigationController?.pushViewController(MedicalVaultViewController(), animated: true)
    }

    private func createSeparator(fullWidth: Bool = false) -> UIView {
        let v = UIView()
        v.backgroundColor = .saanjhaSoftPink.withAlphaComponent(0.3)
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }
}
