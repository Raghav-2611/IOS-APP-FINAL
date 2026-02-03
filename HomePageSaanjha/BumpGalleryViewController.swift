import UIKit

class BumpGalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bump gallery"
        view.backgroundColor = .saanjhaLightPink

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(close)
        )

        let label = UILabel()
        label.text = "Here you’ll see your bump photos in a gentle timeline.\nLong-press the bump card anytime to revisit them. 💕"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}
