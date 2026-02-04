import UIKit

// MARK: - 1. Theme & Models
extension UIColor {
    static let accentRose = UIColor(red: 247/255, green: 120/255, blue: 107/255, alpha: 1.0)
}

struct InsightItem: Hashable {
    let id = UUID() 
    let title: String
    let text: String
    let imageName: String?
    let category: InsightCategory
    var isSaved: Bool = false
    
    enum InsightCategory { case warning, myth, saved }
    
    // Modern hashing for Diffable Data Source
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: InsightItem, rhs: InsightItem) -> Bool {
        return lhs.id == rhs.id && lhs.isSaved == rhs.isSaved
    }
}

// MARK: - 2. Elegant Insight Cell
final class InsightCell: UICollectionViewCell {
    static let reuseId = "InsightCell"
    
    var onShare: (() -> Void)?
    var onSave: (() -> Void)?
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let readMoreLabel = UILabel()
    private let actionStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // PREMIUM: Interactive Scaling Effect
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) { self.transform = .identity }
    }
    
    private func setupUI() {
        containerView.backgroundColor = .secondarySystemGroupedBackground
        containerView.layer.cornerRadius = 28
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.cornerCurve = .continuous
        imageView.backgroundColor = .quaternarySystemFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bodyLabel.font = .preferredFont(forTextStyle: .subheadline)
        bodyLabel.adjustsFontForContentSizeCategory = true
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 3
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))?.withTintColor(.accentRose)
        let string = NSMutableAttributedString(string: "Read More  ", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: UIColor.accentRose])
        string.append(NSAttributedString(attachment: attachment))
        readMoreLabel.attributedText = string
        readMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let shareBtn = UIButton(primaryAction: UIAction(image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in self.onShare?() }))
        let saveBtn = UIButton(primaryAction: UIAction(image: UIImage(systemName: "bookmark"), handler: { _ in self.onSave?() }))
        
        [shareBtn, saveBtn].forEach {
            $0.tintColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
            $0.layer.shadowRadius = 2
            actionStack.addArrangedSubview($0)
        }
        actionStack.spacing = 16
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        [imageView, titleLabel, bodyLabel, readMoreLabel, actionStack].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.45),
            
            actionStack.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            actionStack.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            readMoreLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            readMoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    func configure(with item: InsightItem) {
        titleLabel.text = item.title
        bodyLabel.text = item.text
        
        if let saveBtn = actionStack.arrangedSubviews.last as? UIButton {
            let config = UIImage(systemName: item.isSaved ? "bookmark.fill" : "bookmark")
            saveBtn.setImage(config, for: .normal)
            saveBtn.tintColor = item.isSaved ? .accentRose : .white
        }
        
        if let imageName = item.imageName, let assetImage = UIImage(named: imageName) {
            imageView.image = assetImage
            imageView.contentMode = .scaleAspectFill
        } else {
            // High-quality SF Symbol Fallbacks
            let symbol = item.category == .warning ? "exclamationmark.triangle.fill" : "lightbulb.fill"
            imageView.image = UIImage(systemName: symbol)
            imageView.tintColor = .accentRose
            imageView.contentMode = .center
        }
    }
}

// MARK: - 3. Section Header
class SectionHeader: UICollectionReusableView {
    static let reuseId = "SectionHeader"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - 4. Main Controller
class InsightsViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case warnings, myths, saved
        var title: String {
            switch self {
            case .warnings: return "Warning Signs"
            case .myths: return "Common Myths"
            case .saved: return "Saved Insights"
            }
        }
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, InsightItem>!
    
    private var warnings: [InsightItem] = [
        InsightItem(title: "Severe Bleeding", text: "Heavy bleeding requires immediate attention. It is always best to be cautious.", imageName: "warning_bleeding_cramps", category: .warning),
        InsightItem(title: "High Fever", text: "A temperature over 101°F can indicate infection. Contact your provider early.", imageName: "warning_high_fever", category: .warning),
        InsightItem(title: "Severe Headaches", text: "Persistent headaches with vision changes help monitor blood pressure closely.", imageName: "warning_headache_vision", category: .warning)
    ]
    
    private var myths: [InsightItem] = [
        InsightItem(title: "Exercise Safety", text: "Movement is medicine! Light yoga and walking help prepare your body.", imageName: "myth_no_exercise", category: .myth),
        InsightItem(title: "Diet & Gender", text: "Cravings don't determine sex. Your baby's gender was set at conception.", imageName: "myth_diet_gender", category: .myth),
        InsightItem(title: "Spicy Food", text: "It is safe to enjoy spice, though it may cause some extra heartburn.", imageName: "myth_spicy_food", category: .myth)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        configureDataSource()
        applySnapshot(animating: false)
    }
    
    private func setupNavigation() {
        title = "Insights"
        view.backgroundColor = .saanjhaLightPink
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.register(InsightCell.self, forCellWithReuseIdentifier: InsightCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.82), heightDimension: .absolute(340))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }

    // MARK: - Diffable Data Source Logic (The Modern Way)
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, InsightItem>(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InsightCell.reuseId, for: indexPath) as! InsightCell
            cell.configure(with: item)
            
            cell.onSave = { self?.toggleSave(for: item) }
            cell.onShare = { self?.share(item: item) }
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as! SectionHeader
            header.label.text = Section(rawValue: indexPath.section)?.title
            return header
        }
    }
    
    private func applySnapshot(animating: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, InsightItem>()
        snapshot.appendSections([.warnings, .myths])
        snapshot.appendItems(warnings, toSection: .warnings)
        snapshot.appendItems(myths, toSection: .myths)
        
        let savedItems = (warnings + myths).filter { $0.isSaved }
        if !savedItems.isEmpty {
            snapshot.appendSections([.saved])
            snapshot.appendItems(savedItems, toSection: .saved)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animating)
    }
    
    private func toggleSave(for item: InsightItem) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        // Find and update item in source arrays
        if let idx = warnings.firstIndex(where: { $0.id == item.id }) {
            warnings[idx].isSaved.toggle()
        } else if let idx = myths.firstIndex(where: { $0.id == item.id }) {
            myths[idx].isSaved.toggle()
        }
        
        applySnapshot() // Diffable handles the beautiful "move to saved" animation
    }
    
    private func share(item: InsightItem) {
        let activity = UIActivityViewController(activityItems: [item.title, item.text], applicationActivities: nil)
        present(activity, animated: true)
    }
}

// MARK: - Delegate Logic
extension InsightsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailVC = InsightDetailViewController(item: item)
        let nav = UINavigationController(rootViewController: detailVC)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
}

// MARK: - 6. Modern Detail View
class InsightDetailViewController: UIViewController {
    let item: InsightItem
    
    init(item: InsightItem) { self.item = item; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        
        let bodyLabel = UILabel()
        bodyLabel.font = .preferredFont(forTextStyle: .body)
        bodyLabel.text = item.text
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .secondaryLabel
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    @objc func close() { dismiss(animated: true) }
}
