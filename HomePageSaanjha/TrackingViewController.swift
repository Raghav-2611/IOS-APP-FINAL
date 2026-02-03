import UIKit

// MARK: - Main Controller
class TrackingViewController: UIViewController {

    // In-memory data for the dashboard (can later be persisted)
    public var trackerData: [String: TrackerData] = [
        "bump": TrackerData(stat: "Week 12", status: "Last photo: Mon"),
        "kicks": TrackerData(stat: "12", status: "Active morning"),
        "weight": TrackerData(stat: "65.2 kg", status: "Steady gain"),
        "mood": TrackerData(stat: "Peaceful", status: "Mindful day"),
        "water": TrackerData(stat: "1.8 L", status: "Sipping through the day"),
        "contractions": TrackerData(stat: "0", status: "Unlocks later")
    ]

    // List of tracker items in priority order
    public let trackers: [TrackerItem] = [
        TrackerItem(
            id: "weight",
            name: "Weight log",
            imageAsset: "img_weight",
            accentColor: .systemIndigo,
            unit: "kg",
            description: "Gentle check-in for you and baby.",
            type: .numericInput,
            isEnabled: true
        ),
        TrackerItem(
            id: "water",
            name: "Water intake",
            imageAsset: "img_water",
            accentColor: .systemBlue,
            unit: "L",
            description: "Small sips all day add up.",
            type: .numericInput,
            isEnabled: true
        ),
        TrackerItem(
            id: "mood",
            name: "Mood check-in",
            imageAsset: "img_mood",
            accentColor: .systemOrange,
            unit: "",
            description: "Name how you feel today—everything is welcome.",
            type: .selection,
            isEnabled: true
        ),
        TrackerItem(
            id: "bump",
            name: "Bump photos",
            imageAsset: "img_bump",
            accentColor: .saanjhaSoftPink,
            unit: "Week",
            description: "Capture your growing glow.",
            type: .photoGallery,
            isEnabled: true
        ),
        TrackerItem(
            id: "kicks",
            name: "Kick counter",
            imageAsset: "img_kicks",
            accentColor: .systemGreen,
            unit: "Today",
            description: "Count those fluttery hello kicks.",
            type: .counter,
            isEnabled: true
        ),
        TrackerItem(
            id: "contractions",
            name: "Contraction timer",
            imageAsset: "img_timer",
            accentColor: .systemRed,
            unit: "Sessions",
            description: "Available in the third trimester.",
            type: .counter,
            isEnabled: false
        )
    ]

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .saanjhaLightPink
        setupNavigationBar()
        setupCollectionView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataUpdated),
            name: NSNotification.Name("DataUpdated"),
            object: nil
        )
    }

    private func setupNavigationBar() {
        title = "Daily Tracking"
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .saanjhaLightPink
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.saanjhaDarker,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.saanjhaDarker,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    // 2-column card grid with good hierarchy: title, latest value, icon.[web:24]
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(190)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 20,
            bottom: 24,
            trailing: 20
        )
        section.interGroupSpacing = 8

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupCollectionView() {
        let layout = createCompositionalLayout()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TrackerCardCell.self,
            forCellWithReuseIdentifier: TrackerCardCell.reuseId
        )

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // One long‑press recognizer for graphs on every card
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressOnCollection(_:))
        )
        longPress.minimumPressDuration = 0.6
        collectionView.addGestureRecognizer(longPress)
    }

    @objc private func handleLongPressOnCollection(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }

        let item = trackers[indexPath.item]
        let summaryVC = SummaryGraphViewController(item: item)
        let nav = UINavigationController(rootViewController: summaryVC)

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 28
        }

        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        present(nav, animated: true)
    }

    @objc private func handleDataUpdated() {
        collectionView.reloadData()
    }



    // Long press specifically on bump card to open gallery view
    @objc func handleBumpLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
            let item = trackers[indexPath.item]
            guard item.id == "bump" else { return }

            let galleryVC = BumpGalleryViewController()
            let nav = UINavigationController(rootViewController: galleryVC)
            present(nav, animated: true)
        }
    }
}

// MARK: - CollectionView & ImagePicker Delegates
extension TrackingViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        trackers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardCell.reuseId,
            for: indexPath
        ) as? TrackerCardCell else {
            return UICollectionViewCell()
        }

        let item = trackers[indexPath.item]
        let data = trackerData[item.id] ?? TrackerData(stat: "-", status: "")

        // Only bump card shows the status line (“Last photo: …”)
        let subtitle: String? = (item.id == "bump") ? data.status : nil

        cell.configure(
            with: item,
            heading: item.name,
            value: data.stat,
            subtitle: subtitle
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let item = trackers[indexPath.item]

        if item.id == "contractions", !item.isEnabled {
            let alert = UIAlertController(
                title: "Coming a little later",
                message: "This timer gently unlocks in your third trimester to help you time contractions and feel prepared for birth. You’ll see it appear when it’s time. 🌸",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            present(alert, animated: true)
            return
        }

        // Bump: open camera directly (short tap)
        if item.id == "bump" {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true)
            return
        }

        let detailVC = DetailTrackerViewController(item: item)
        let nav = UINavigationController(rootViewController: detailVC)

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 28
        }

        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        present(nav, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Later: save photo, update trackerData["bump"]
        picker.dismiss(animated: true)
    }
}

// MARK: - Tracker Card Cell
class TrackerCardCell: UICollectionViewCell {
    static let reuseId = "TrackerCardCell"

    private let container = UIView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let helperLabel = UILabel()   // “Tap to add photo…” / “You logged today”
    private let imageView = UIImageView()

    private var currentItem: TrackerItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 24
        container.backgroundColor = .white
        container.applyClayShadow()

        // Accessibility: treat whole card as one element with hint + custom actions.[web:18][web:92]
        container.isAccessibilityElement = true
        container.accessibilityTraits = [.button]

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .saanjhaDarker
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontForContentSizeCategory = true

        valueLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        valueLabel.textColor = .secondaryLabel
        valueLabel.numberOfLines = 1
        valueLabel.adjustsFontForContentSizeCategory = true

        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2
        subtitleLabel.adjustsFontForContentSizeCategory = true

        helperLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        helperLabel.textColor = .tertiaryLabel
        helperLabel.numberOfLines = 2
        helperLabel.adjustsFontForContentSizeCategory = true

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel, subtitleLabel, helperLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.alignment = .fill
        textStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(textStack)
        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            imageView.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),

            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: 3.0 / 4.0
            ),

            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 180)
        ])
    }

    func configure(with item: TrackerItem,
                   heading: String,
                   value: String,
                   subtitle: String?) {

        currentItem = item

        titleLabel.text = heading
        valueLabel.text = value

        // Only bump shows a status line (week + last photo)
        if let subtitle = subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true
        }

        // Helper copy: camera text for bump, shared‑journey text for others
        switch item.id {
        case "bump":
            helperLabel.text = "Tap to add photo, hold to view your bump gallery."
        case "weight", "water":
            helperLabel.text = "You logged today. Your partner can see this too."
        case "mood":
            helperLabel.text = "A quick check‑in for how you’re both feeling."
        case "kicks":
            helperLabel.text = "Use when baby’s movements become more regular."
        case "contractions":
            helperLabel.text = "Unlocks later in pregnancy to time contractions."
        default:
            helperLabel.text = nil
        }

        imageView.image = UIImage(named: item.imageAsset)
            ?? UIImage(systemName: "heart.fill")

        container.alpha = item.isEnabled ? 1.0 : 0.45

        // Accessibility label + hint + custom action for trends.[web:92][web:96][web:102]
        let valuePart = value.isEmpty ? "" : ", latest \(value)"
        container.accessibilityLabel = "\(heading)\(valuePart)"

        var hint = "Double‑tap to open."
        if item.id == "bump" {
            hint += " Double‑tap to add a bump photo; long‑press for your gallery."
        } else {
            hint += " Long‑press for your trends."
        }
        container.accessibilityHint = hint

        let trendsAction = UIAccessibilityCustomAction(
            name: "Show trends",
            target: self,
            selector: #selector(accessibilityShowTrends)
        )
        container.accessibilityCustomActions = [trendsAction]
    }

    // This doesn’t open the graph itself (that’s handled by the controller),
    // but lets VoiceOver users know there is an action.
    @objc private func accessibilityShowTrends() -> Bool {
        // VoiceOver users will typically long‑press or use the custom action selector
        // that the view controller exposes via gesture; returning true is enough here.
        return true
    }
}
