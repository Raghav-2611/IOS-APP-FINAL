import UIKit

class DetailTrackerViewController: UIViewController {

    let item: TrackerItem
    var sessionCount = 0
    var timer: Timer?
    var secondsElapsed = 0

    private let actionButton = UIButton(type: .system)
    private let timerLabel = UILabel()
    private let statusLabel = UILabel()

    init(item: TrackerItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .saanjhaLightPink
        title = item.name

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(close)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )

        setupUI()
    }

    // MARK: - Entry point

    private func setupUI() {
        switch item.type {
        case .counter:
            setupKickUI()
        case .selection:
            setupMoodUI()
        case .numericInput:
            setupInputUI()
        case .photoGallery:
            setupPhotoPlaceholder()
        }
    }

    // MARK: - 1. Kick Counter

    private func setupKickUI() {
        timerLabel.text = "00:00"
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 44, weight: .regular)
        timerLabel.textColor = .saanjhaDarker
        timerLabel.textAlignment = .center
        timerLabel.adjustsFontForContentSizeCategory = true

        statusLabel.text = item.description
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.preferredFont(forTextStyle: .body)
        statusLabel.textColor = .secondaryLabel
        statusLabel.adjustsFontForContentSizeCategory = true

        actionButton.backgroundColor = item.accentColor
        actionButton.setTitle("Start session", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 96
        actionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        actionButton.applyClayShadow()
        actionButton.addTarget(self, action: #selector(kickTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [timerLabel, actionButton, statusLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            actionButton.widthAnchor.constraint(equalToConstant: 192),
            actionButton.heightAnchor.constraint(equalToConstant: 192),
            statusLabel.widthAnchor.constraint(equalTo: stack.widthAnchor)
        ])
    }

    @objc private func kickTapped() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if timer == nil {
            startSession()
        } else {
            sessionCount += 1
            actionButton.setTitle("\(sessionCount) kicks", for: .normal)

            UIView.animate(withDuration: 0.1, animations: {
                self.actionButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.actionButton.transform = .identity
                }
            }
        }
    }

    private func startSession() {
        secondsElapsed = 0
        sessionCount = 0
        timerLabel.text = "00:00"
        actionButton.setTitle("Tap for each kick", for: .normal)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.secondsElapsed += 1
            let m = self.secondsElapsed / 60
            let s = self.secondsElapsed % 60
            self.timerLabel.text = String(format: "%02d:%02d", m, s)
        }
    }

    // MARK: - 2. Mood Selection

    private func setupMoodUI() {
        let title = UILabel()
        title.text = "How are you feeling, Mama?"
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.textAlignment = .center
        title.adjustsFontForContentSizeCategory = true

        let subtitle = UILabel()
        subtitle.text = "Every feeling belongs here—good, hard, or in‑between. Choose what fits right now."
        subtitle.font = UIFont.preferredFont(forTextStyle: .body)
        subtitle.textAlignment = .center
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0
        subtitle.adjustsFontForContentSizeCategory = true

        let scrollView = UIScrollView()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(title)
        view.addSubview(subtitle)
        view.addSubview(scrollView)
        scrollView.addSubview(stack)

        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        Mood.allCases.forEach { mood in
            let btn = UIButton(type: .system)
            btn.setTitle(mood.rawValue, for: .normal)
            btn.backgroundColor = .white
            btn.layer.cornerRadius = 22
            btn.tintColor = .saanjhaDarker
            btn.setTitleColor(.saanjhaDarker, for: .normal)
            btn.contentHorizontalAlignment = .leading
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12)
            btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            btn.applyClayShadow()
            btn.heightAnchor.constraint(equalToConstant: 56).isActive = true
            stack.addArrangedSubview(btn)
        }

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            scrollView.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - 3. Numeric Input (weight / water)

    private func setupInputUI() {
        let title = UILabel()
        title.text = item.id == "water" ? "Today’s water" : "Today’s weight"
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.textAlignment = .center
        title.adjustsFontForContentSizeCategory = true

        let subtitle = UILabel()
        subtitle.text = item.id == "water"
        ? "A gentle goal is sipping small amounts all through the day."
        : "Numbers are just information. Your care team can help interpret them."
        subtitle.font = UIFont.preferredFont(forTextStyle: .body)
        subtitle.textAlignment = .center
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0
        subtitle.adjustsFontForContentSizeCategory = true

        let textField = UITextField()
        textField.placeholder = item.id == "water" ? "1.8" : "65.2"
        textField.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.textColor = item.accentColor
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 18
        textField.layer.masksToBounds = true

        let unitLabel = UILabel()
        unitLabel.text = item.unit
        unitLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        unitLabel.textColor = .secondaryLabel

        let unitStack = UIStackView(arrangedSubviews: [textField, unitLabel])
        unitStack.axis = .horizontal
        unitStack.spacing = 12
        unitStack.alignment = .center
        unitStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(title)
        view.addSubview(subtitle)
        view.addSubview(unitStack)

        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            unitStack.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 36),
            unitStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unitStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            unitStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),

            textField.widthAnchor.constraint(equalToConstant: 140),
            textField.heightAnchor.constraint(equalToConstant: 64)
        ])

        textField.becomeFirstResponder()
    }

    // MARK: - 4. Bump photo placeholder (used when item.type == .photoGallery)

    private func setupPhotoPlaceholder() {
        let title = UILabel()
        title.text = "Your bump story"
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.textAlignment = .center
        title.adjustsFontForContentSizeCategory = true

        let subtitle = UILabel()
        subtitle.text = "You can add a bump photo on days that feel special. No pressure, just memories for future you."
        subtitle.font = UIFont.preferredFont(forTextStyle: .body)
        subtitle.textAlignment = .center
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0
        subtitle.adjustsFontForContentSizeCategory = true

        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.applyClayShadow()
        card.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "camera.fill"))
        icon.tintColor = .saanjhaSoftPink
        icon.translatesAutoresizingMaskIntoConstraints = false

        let text = UILabel()
        text.text = "Tap save when you’re ready to start capturing bump photos. Long‑press the bump card later to revisit your gallery. 💕"
        text.font = UIFont.preferredFont(forTextStyle: .footnote)
        text.textColor = .secondaryLabel
        text.numberOfLines = 0
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(icon)
        card.addSubview(text)

        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            icon.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),

            text.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            text.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            text.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            text.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])

        view.addSubview(title)
        view.addSubview(subtitle)
        view.addSubview(card)

        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            card.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 24),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            card.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Shared

    @objc private func saveTapped() {
        let messages = [
            "Lovely! Your entry has been saved. ✨",
            "You showed up for you and baby today. 🌸",
            "Recorded. You’re doing such an amazing job, even on the quieter days. 💖"
        ]

        let alert = UIAlertController(
            title: "Saved",
            message: messages.randomElement(),
            preferredStyle: .alert
        )

        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            alert.dismiss(animated: true) {
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("DataUpdated"),
                        object: nil
                    )
                }
            }
        }
    }

    @objc private func close() {
        timer?.invalidate()
        dismiss(animated: true)
    }
}
