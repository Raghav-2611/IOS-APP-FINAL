import UIKit

// MARK: - Weight Chart with labels
final class WeightTrendChartView: UIView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 24
        applyClayShadow()

        titleLabel.text = "Weight over recent weeks"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .saanjhaDarker

        subtitleLabel.text = "This gentle line simply shows your pattern. Share with your doctor for medical interpretation."
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        isAccessibilityElement = true
        accessibilityLabel = "Weight trend"
        accessibilityHint = "Shows how your weight has changed over the last few weeks."
    }

    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let padding: CGFloat = 40
        let titleHeight: CGFloat = 60
        let chartTop = padding + titleHeight
        let h = rect.height - (chartTop + padding)
        let w = rect.width - (padding * 2)

        let dataPoints: [CGFloat] = [62.0, 62.8, 63.5, 64.1, 65.0, 65.2]
        let maxVal: CGFloat = 70.0
        let minVal: CGFloat = 60.0

        // Safe zone band
        context.setFillColor(UIColor.systemGreen.withAlphaComponent(0.08).cgColor)
        let yStart = chartTop + h * (1 - (66.5 - minVal) / (maxVal - minVal))
        let yEnd = chartTop + h * (1 - (63.0 - minVal) / (maxVal - minVal))
        context.fill(CGRect(x: padding, y: yStart, width: w, height: yEnd - yStart))

        // Baseline grid
        context.setStrokeColor(UIColor.systemGray5.cgColor)
        context.setLineWidth(1)
        let midY = chartTop + h / 2
        context.move(to: CGPoint(x: padding, y: midY))
        context.addLine(to: CGPoint(x: padding + w, y: midY))
        context.strokePath()

        // Progress line
        let path = UIBezierPath()
        context.setStrokeColor(UIColor.saanjhaSoftPink.cgColor)
        context.setLineWidth(3)

        for (i, val) in dataPoints.enumerated() {
            let x = padding + (CGFloat(i) * (w / CGFloat(dataPoints.count - 1)))
            let y = chartTop + h * (1 - (val - minVal) / (maxVal - minVal))
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.lineCapStyle = .round
        path.stroke()

        // Simple labels for start and latest
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .caption2),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let firstText = "Week 1"
        firstText.draw(at: CGPoint(x: padding, y: chartTop + h + 4), withAttributes: attributes)

        let lastText = "Today"
        let lastWidth = (lastText as NSString).size(withAttributes: attributes).width
        lastText.draw(at: CGPoint(x: padding + w - lastWidth, y: chartTop + h + 4), withAttributes: attributes)
    }
}

// MARK: - Trends VC
class SummaryGraphViewController: UIViewController {

    let item: TrackerItem

    init(item: TrackerItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .saanjhaLightPink
        title = "\(item.name) trends"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(close)
        )

        setupLayout()
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    private func setupLayout() {
        let card: UIView = (item.id == "weight") ? WeightTrendChartView() : createPlaceholder()
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)

        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            card.heightAnchor.constraint(equalToConstant: 340)
        ])
    }

    private func createPlaceholder() -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        v.applyClayShadow()

        let title = UILabel()
        title.text = "\(item.name) story"
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .saanjhaDarker

        let l = UILabel()
        l.text = "As you log more \(item.name.lowercased()), this screen will gently turn your days into a timeline you can revisit any time. 🌷"
        l.numberOfLines = 0
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.font = UIFont.preferredFont(forTextStyle: .body)

        let stack = UIStackView(arrangedSubviews: [title, l])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        v.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: v.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -20)
        ])

        return v
    }
}
