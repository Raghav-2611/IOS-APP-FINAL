import UIKit
import FirebaseAuth

// MARK: - 2. Data Models
struct DailyTask: Hashable {
    let id = UUID()
    var title: String
    var subtext: String
    var icon: String
    var color: UIColor
    var isCompleted: Bool = false
}

// MARK: - 3. Interactive Task Cell
class InteractiveTaskCell: UICollectionViewListCell {
    static let reuseIdentifier = "InteractiveTaskCell"

    func configure(with task: DailyTask) {
        var content = defaultContentConfiguration()

        if task.isCompleted {
            let attributeString = NSMutableAttributedString(string: task.title)
            attributeString.addAttribute(.strikethroughStyle,
                                         value: 2,
                                         range: NSMakeRange(0, attributeString.length))
            content.attributedText = attributeString
            content.textProperties.color = .secondaryLabel
            content.secondaryText = "Completed"
        } else {
            content.text = task.title
            content.secondaryText = task.subtext
            content.textProperties.color = .saanjhaDarker
            content.secondaryTextProperties.color = .secondaryLabel
        }

        let iconColor = task.isCompleted ? .systemGray4 : task.color.iconTintColor
        let symbolConfig = UIImage.SymbolConfiguration(
            paletteColors: [iconColor, iconColor.withAlphaComponent(0.2)]
        )
        content.image = UIImage(
            systemName: task.isCompleted ? "checkmark.circle.fill" : task.icon,
            withConfiguration: symbolConfig
        )

        self.contentConfiguration = content

        var bg = UIBackgroundConfiguration.listGroupedCell()
        bg.backgroundColor = task.isCompleted ? .systemGray6.withAlphaComponent(0.3) : .white
        bg.cornerRadius = 22
        self.backgroundConfiguration = bg

        let accessoryImg = task.isCompleted ? "checkmark.circle.fill" : "circle"
        let accView = UIImageView(image: UIImage(systemName: accessoryImg))
        accView.tintColor = task.isCompleted ? .systemGreen : .systemGray4
        self.accessories = [.customView(configuration: .init(customView: accView,
                                                             placement: .trailing()))]
    }
}

// MARK: - 4. Partner Pill Cell
// MARK: - Updated Partner Pill Cell
class PartnerPillCell: UICollectionViewCell {
    static let reuseIdentifier = "PartnerPillCell"
    
    private let pillView = UIView()
    private let avatarImageView = UIImageView()
    private let statusDot = UIView()
    private let mainTextLabel = UILabel()
    private let activityLabel = UILabel() // "Just saw Week 12 update"
    
    // Quick Reaction Button
    private let reactionButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        btn.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .systemRed
        btn.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 15
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        // Pill Background
        pillView.backgroundColor = .white
        pillView.layer.cornerRadius = 28
        pillView.layer.shadowColor = UIColor.black.cgColor
        pillView.layer.shadowOpacity = 0.05
        pillView.layer.shadowOffset = CGSize(width: 0, height: 4)
        pillView.layer.shadowRadius = 10
        
        // Avatar + Status Dot
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .systemGray3
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        
        statusDot.backgroundColor = .systemGreen
        statusDot.layer.cornerRadius = 5
        statusDot.layer.borderWidth = 1.5
        statusDot.layer.borderColor = UIColor.white.cgColor

        // Labels
        mainTextLabel.text = "John"
        mainTextLabel.font = .systemFont(ofSize: 15, weight: .bold)
        mainTextLabel.textColor = .label

        activityLabel.text = "Just saw the Week 12 update"
        activityLabel.font = .systemFont(ofSize: 12, weight: .regular)
        activityLabel.textColor = .secondaryLabel

        let labelStack = UIStackView(arrangedSubviews: [mainTextLabel, activityLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 1

        let contentStack = UIStackView(arrangedSubviews: [avatarImageView, labelStack, UIView(), reactionButton])
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 12

        [pillView, contentStack, statusDot].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            pillView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pillView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pillView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pillView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),
            
            statusDot.widthAnchor.constraint(equalToConstant: 10),
            statusDot.heightAnchor.constraint(equalToConstant: 10),
            statusDot.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 2),
            statusDot.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -2),

            reactionButton.widthAnchor.constraint(equalToConstant: 30),
            reactionButton.heightAnchor.constraint(equalToConstant: 30),

            contentStack.leadingAnchor.constraint(equalTo: pillView.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: pillView.trailingAnchor, constant: -16),
            contentStack.centerYAnchor.constraint(equalTo: pillView.centerYAnchor)
        ])
        
        // Add a subtle pulse to the status dot
        addPulseAnimation()
    }
    
    private func addPulseAnimation() {
        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.duration = 0.8
        pulse.fromValue = 1.0
        pulse.toValue = 0.4
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        statusDot.layer.add(pulse, forKey: nil)
    }
}

// MARK: - 5. Modern Hero Cell
class HomeHeroCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeHeroCell"

    private let backgroundContainer = UIView()
    private let babyImageView = UIImageView()
    private let cardView = UIView()
    private let helloLabel = UILabel()
    private let weekLabel = UILabel()
    private let factLabel = UILabel()
    private let progressTrack = UIView()
    private let progressFill = UIView()
    private let progressLabel = UILabel()

    // dynamic width constraint for progress
    private var progressWidthConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Configure hero content for a specific week
    func configure(currentWeek: Int) {
        let clampedWeek = max(1, min(currentWeek, 40))
        let fraction = CGFloat(clampedWeek) / 40.0

        weekLabel.text = "Week \(clampedWeek)"
        progressLabel.text = "This week"

        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressFill.widthAnchor.constraint(
            equalTo: progressTrack.widthAnchor,
            multiplier: fraction
        )
        progressWidthConstraint?.isActive = true

        layoutIfNeeded()
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundContainer)

        NSLayoutConstraint.activate([
            backgroundContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // HERO IMAGE – edge to edge
        babyImageView.translatesAutoresizingMaskIntoConstraints = false
        babyImageView.image = UIImage(named: "Week12Baby")
        babyImageView.contentMode = .scaleAspectFill   // fills width; top under status/nav
        babyImageView.clipsToBounds = true
        backgroundContainer.addSubview(babyImageView)

        // Card – refined
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.93)
        cardView.layer.cornerRadius = 22
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 16
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        backgroundContainer.addSubview(cardView)

        helloLabel.text = "Hello Meher"
        helloLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        helloLabel.textColor = .label

        weekLabel.text = "Week 12"
        weekLabel.font = .systemFont(ofSize: 26, weight: .bold)
        weekLabel.textColor = .label

        factLabel.text = "Reflexes are developing. Tiny fingers can now open and close."
        factLabel.numberOfLines = 0
        factLabel.font = .systemFont(ofSize: 14, weight: .regular)
        factLabel.textColor = .secondaryLabel

        // Linear progress – minimal
        progressTrack.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.7)
        progressTrack.layer.cornerRadius = 3

        progressFill.backgroundColor = .saanjhaSoftPink
        progressFill.layer.cornerRadius = 3
        progressFill.translatesAutoresizingMaskIntoConstraints = false

        progressLabel.text = "This week"
        progressLabel.font = .systemFont(ofSize: 12, weight: .medium)
        progressLabel.textColor = .secondaryLabel
        progressLabel.setContentHuggingPriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [helloLabel, weekLabel, factLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let progressStack = UIStackView(arrangedSubviews: [progressTrack, progressLabel])
        progressStack.axis = .horizontal
        progressStack.spacing = 8
        progressStack.alignment = .center
        progressStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(textStack)
        cardView.addSubview(progressStack)
        progressTrack.translatesAutoresizingMaskIntoConstraints = false
        progressTrack.addSubview(progressFill)

        // Layout
        NSLayoutConstraint.activate([
            babyImageView.topAnchor.constraint(equalTo: backgroundContainer.topAnchor),
            babyImageView.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor),
            babyImageView.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor),
            babyImageView.heightAnchor.constraint(equalTo: backgroundContainer.heightAnchor,
                                                  multiplier: 0.72),

            cardView.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -8),
            cardView.topAnchor.constraint(equalTo: babyImageView.bottomAnchor, constant: -28),

            textStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            textStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            progressStack.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 10),
            progressStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            progressStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            progressStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            progressTrack.heightAnchor.constraint(equalToConstant: 6),

            progressFill.leadingAnchor.constraint(equalTo: progressTrack.leadingAnchor),
            progressFill.centerYAnchor.constraint(equalTo: progressTrack.centerYAnchor),
            progressFill.heightAnchor.constraint(equalTo: progressTrack.heightAnchor)
            // width set in configure()
        ])
    }
}

// MARK: - 6. Home View Controller
class HomeViewController: UIViewController, UICollectionViewDelegate {

    enum Section: Int, CaseIterable {
        case hero, partner, tasks
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private var tasks = [
        DailyTask(title: "Nourish: Prenatal Vitamins", subtext: "Daily Wellness", icon: "pills.fill", color: .systemPink),
        DailyTask(title: "Energy: Light Yoga", subtext: "Body Connection", icon: "figure.walk", color: .systemGreen),
        DailyTask(title: "Hydrate: Stay Refreshed", subtext: "1 of 3 Liters", icon: "drop.fill", color: .systemBlue)
    ]

    private let currentWeek = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        configureDataSource()
        applySnapshot()
    }

    // MARK: Navigation bar with profile icon
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let profileBtn = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(profileTapped)
        )
        profileBtn.tintColor = .saanjhaDarker
        navigationItem.rightBarButtonItem = profileBtn
    }

    @objc private func profileTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: CollectionView setup
    private func setupUI() {
        view.backgroundColor = .saanjhaLightPink

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never // hero under status bar

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.register(HomeHeroCell.self, forCellWithReuseIdentifier: HomeHeroCell.reuseIdentifier)
        collectionView.register(PartnerPillCell.self, forCellWithReuseIdentifier: PartnerPillCell.reuseIdentifier)
        collectionView.register(InteractiveTaskCell.self, forCellWithReuseIdentifier: InteractiveTaskCell.reuseIdentifier)
    }

    // MARK: Compositional Layout
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (idx, env) in
            guard let section = Section(rawValue: idx) else { return nil }

            switch section {
            case .hero:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(env.container.effectiveContentSize.height * 0.65)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = .zero
                return sectionLayout

            case .partner:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let s = NSCollectionLayoutSection(group: group)
                s.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24,
                                                          bottom: 8, trailing: 24)
                return s

            case .tasks:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(85)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let s = NSCollectionLayoutSection(group: group)
                s.interGroupSpacing = 12
                s.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20,
                                                          bottom: 40, trailing: 20)
                return s
            }
        }
        
    }

    // MARK: Diffable Data Source
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView
        ) { [weak self] (cv, indexPath, item) in
            guard let self = self else { return nil }

            switch Section(rawValue: indexPath.section)! {
            case .hero:
                let cell = cv.dequeueReusableCell(
                    withReuseIdentifier: HomeHeroCell.reuseIdentifier,
                    for: indexPath
                ) as! HomeHeroCell
                cell.configure(currentWeek: self.currentWeek)
                return cell

            case .partner:
                return cv.dequeueReusableCell(
                    withReuseIdentifier: PartnerPillCell.reuseIdentifier,
                    for: indexPath
                )

            case .tasks:
                let cell = cv.dequeueReusableCell(
                    withReuseIdentifier: InteractiveTaskCell.reuseIdentifier,
                    for: indexPath
                ) as! InteractiveTaskCell
                if let task = item as? DailyTask {
                    cell.configure(with: task)
                }
                return cell
            }
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.hero, .partner, .tasks])
        snapshot.appendItems(["HeroID"], toSection: .hero)
        snapshot.appendItems(["PartnerID"], toSection: .partner)
        snapshot.appendItems(tasks, toSection: .tasks)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: Selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == Section.tasks.rawValue else { return }
        UISelectionFeedbackGenerator().selectionChanged()
        tasks[indexPath.item].isCompleted.toggle()
        applySnapshot()
    }
    @IBAction func logoutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            view.window?.rootViewController = loginVC
        } catch {
            print("Logout failed")
        }
    }
}
