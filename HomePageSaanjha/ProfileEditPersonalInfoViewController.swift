import UIKit
import PhotosUI

class ProfileEditPersonalInfoViewController: UIViewController, PHPickerViewControllerDelegate {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    // Profile Image
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill")
        iv.tintColor = .saanjhaSoftPink
        iv.layer.cornerRadius = 40
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return iv
    }()

    private let changePhotoButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Change Photo", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        b.setTitleColor(.saanjhaSoftPink, for: .normal)
        return b
    }()

    // TextFields
    private let nameField = UITextField()
    private let ageStepper = UIStepper()
    private let ageLabel = UILabel()
    private let locationField = UITextField()

    // Pregnancy Section
    private let statusPicker = UISegmentedControl(items: [
        "Pregnant", "Trying to Conceive", "Postpartum", "Miscarriage/Loss"
    ])
    private let lmpDatePicker = UIDatePicker()
    private let dueDateLabel = UILabel()

    // MARK: - User Data
    private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Jane Doe"
    private var userAge: Int = {
        let age = UserDefaults.standard.integer(forKey: "userAge")
        return age == 0 ? 32 : age
    }()
    private var userLocation: String = UserDefaults.standard.string(forKey: "userLocation") ?? "San Jose, CA"

    enum PregnancyStatus: String {
        case pregnant = "Pregnant"
        case ttc = "Trying to Conceive"
        case postpartum = "Postpartum"
        case loss = "Miscarriage/Loss"
    }

    private var status: PregnancyStatus = {
        let raw = UserDefaults.standard.string(forKey: "userStatus") ?? "Pregnant"
        return PregnancyStatus(rawValue: raw) ?? .pregnant
    }()

    private var lastPeriodDate: Date = {
        let stored = UserDefaults.standard.object(forKey: "userLMPDate") as? Date
        return stored ?? Calendar.current.date(byAdding: .day, value: -160, to: Date())!
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .saanjhaLightPink
        
        setupNavigation()
        setupScroll()
        setupUI()
        loadSavedData()
    }

    private func setupNavigation() {
        title = "Update Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveProfileTapped)
        )
        navigationController?.navigationBar.tintColor = .saanjhaSoftPink
    }

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func setupUI() {
        // Profile Section
        let profileStack = UIStackView()
        profileStack.axis = .vertical
        profileStack.alignment = .center
        profileStack.spacing = 8

        profileStack.addArrangedSubview(profileImageView)
        profileStack.addArrangedSubview(changePhotoButton)
        changePhotoButton.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)

        contentView.addArrangedSubview(profileStack)

        // Name
        setupField(nameField, placeholder: "Name")
        contentView.addArrangedSubview(nameField)

        // Age
        ageLabel.text = "Age: \(userAge)"
        ageStepper.minimumValue = 18
        ageStepper.maximumValue = 50
        ageStepper.value = Double(userAge)
        ageStepper.addTarget(self, action: #selector(ageChanged), for: .valueChanged)

        let ageStack = UIStackView(arrangedSubviews: [ageLabel, ageStepper])
        ageStack.axis = .horizontal
        ageStack.distribution = .equalSpacing
        contentView.addArrangedSubview(ageStack)

        // Location
        setupField(locationField, placeholder: "Location")
        contentView.addArrangedSubview(locationField)

        // Status picker
        statusPicker.selectedSegmentIndex = {
            switch status {
            case .pregnant: return 0
            case .ttc: return 1
            case .postpartum: return 2
            case .loss: return 3
            }
        }()
        statusPicker.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
        contentView.addArrangedSubview(statusPicker)

        // LMP Date
        lmpDatePicker.datePickerMode = .date
        lmpDatePicker.date = lastPeriodDate
        lmpDatePicker.addTarget(self, action: #selector(lmpChanged), for: .valueChanged)
        contentView.addArrangedSubview(lmpDatePicker)

        // Due Date
        dueDateLabel.textColor = .saanjhaSoftPink
        dueDateLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addArrangedSubview(dueDateLabel)
        
        updateDueDate()
    }

    private func setupField(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.backgroundColor = .white
        field.layer.cornerRadius = 10
        field.setLeftPadding(10)
        field.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func loadSavedData() {
        nameField.text = userName
        locationField.text = userLocation
    }

    // MARK: - Pick Image
    @objc private func openPhotoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let item = results.first?.itemProvider else { return }

        if item.canLoadObject(ofClass: UIImage.self) {
            item.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    if let img = image as? UIImage {
                        self?.profileImageView.image = img
                    }
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func ageChanged() {
        userAge = Int(ageStepper.value)
        ageLabel.text = "Age: \(userAge)"
    }

    @objc private func statusChanged() {
        switch statusPicker.selectedSegmentIndex {
        case 0: status = .pregnant
        case 1: status = .ttc
        case 2: status = .postpartum
        case 3: status = .loss
        default: break
        }
        updateDueDate()
    }

    @objc private func lmpChanged() {
        lastPeriodDate = lmpDatePicker.date
        updateDueDate()
    }

    private func updateDueDate() {
        dueDateLabel.text = "Calculated Due Date: \(formattedDate(calculateDueDate(from: lastPeriodDate)))"
        dueDateLabel.isHidden = status != .pregnant
        lmpDatePicker.isHidden = status != .pregnant
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }

    // MARK: - Save
    @objc private func saveProfileTapped() {
        saveProfile()
        navigationController?.popViewController(animated: true)
    }

    func calculateDueDate(from lmp: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: 280, to: lmp) ?? lmp
    }

    func saveProfile() {
        UserDefaults.standard.set(nameField.text, forKey: "userName")
        UserDefaults.standard.set(userAge, forKey: "userAge")
        UserDefaults.standard.set(locationField.text, forKey: "userLocation")
        UserDefaults.standard.set(status.rawValue, forKey: "userStatus")
        UserDefaults.standard.set(lastPeriodDate, forKey: "userLMPDate")
        saveProfileImage()
    }

    func saveProfileImage() {
        guard let image = profileImageView.image,
              let data = image.jpegData(compressionQuality: 0.8) else { return }

        let filename = "profile_image.jpeg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)

        try? data.write(to: url)
    }
}

// MARK: - Padding helper
extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = padding
        leftViewMode = .always
    }
}
