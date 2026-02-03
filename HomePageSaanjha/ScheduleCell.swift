import UIKit

final class ScheduleCell: UITableViewCell {

    static let reuseIdentifier = "ScheduleCell"

    private let container = UIView()
    private let iconBackground = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let partnerLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        container.layer.cornerRadius = 22
        container.backgroundColor = .white
        container.layer.shadowColor = UIColor.saanjhaSoftPink.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowOffset = CGSize(width: 0, height: 6)
        container.layer.shadowRadius = 10

        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        iconBackground.layer.cornerRadius = 18
        iconBackground.backgroundColor = UIColor.saanjhaSoftPink.withAlphaComponent(0.13)

        iconView.tintColor = .saanjhaSoftPink
        iconView.contentMode = .scaleAspectFit

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .saanjhaDarker

        timeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        timeLabel.adjustsFontForContentSizeCategory = true
        timeLabel.textColor = .secondaryLabel

        partnerLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        partnerLabel.adjustsFontForContentSizeCategory = true
        partnerLabel.textColor = .saanjhaSoftPink

        container.addSubview(iconBackground)
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(timeLabel)
        container.addSubview(partnerLabel)

        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        partnerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            iconBackground.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconBackground.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconBackground.widthAnchor.constraint(equalToConstant: 40),
            iconBackground.heightAnchor.constraint(equalToConstant: 40),

            iconView.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),

            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconBackground.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            partnerLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            partnerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            partnerLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            partnerLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    func configure(with item: ScheduleItem) {
        titleLabel.text = item.title

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        var subtitle = formatter.string(from: item.date)
        
        // Add the Repetition Hint to the subtitle
        if item.repeatRule != .none {
            let ruleString = item.repeatRule.rawValue == "everyDay" ? "Daily" :
                             item.repeatRule.rawValue == "everyWeek" ? "Weekly" : "Monthly"
            subtitle += " • \(ruleString)"
        }
        
        if let notes = item.notes, !notes.isEmpty {
            subtitle += " • \(notes)"
        }
        timeLabel.text = subtitle

        // Visual indicators for Kind
        if item.kind == .task {
            iconView.image = UIImage(systemName: "heart.text.square.fill")
            partnerLabel.text = "Partners can tick this off together"
        } else {
            iconView.image = UIImage(systemName: "calendar.badge.clock")
            partnerLabel.text = "Attend this appointment together"
        }
    }
    
}
