import UIKit

class CalendarDateCell: UICollectionViewCell {
    
    static let reuseID = "CalendarDateCell"
    
    // MARK: - UI Components
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var eventDot: UIView = {
        let view = UIView()
        view.backgroundColor = .saanjhaSoftPink
        view.layer.cornerRadius = 3
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - State Properties
    
    var isDayInMonth: Bool = true {
        didSet {
            dateLabel.textColor = isDayInMonth ? .saanjhaDarker : UIColor.lightGray.withAlphaComponent(0.5)
            isUserInteractionEnabled = isDayInMonth
        }
    }
    
    var isToday: Bool = false {
        didSet {
            // Highlight today's date with a light background
            contentView.backgroundColor = isToday ? UIColor.saanjhaSoftPink.withAlphaComponent(0.1) : .clear
        }
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(eventDot)
                contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5), // Slightly up to make room for dot
            
            // Event dot constraints
            eventDot.widthAnchor.constraint(equalToConstant: 6),
            eventDot.heightAnchor.constraint(equalToConstant: 6),
            eventDot.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eventDot.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2)
        ])
    }
    
    // MARK: - Public Methods
    
    func showEventDot(_ show: Bool) {
        eventDot.isHidden = !show
    }
    
    func updateSelectionState(isSelected: Bool) {
        if isSelected {
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.saanjhaSoftPink.cgColor
        } else {
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        showEventDot(false)
        updateSelectionState(isSelected: false)
        isToday = false
    }
}
