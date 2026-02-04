//
//  VaultAddReportViewController.swift
//

import UIKit
import SwiftData

final class VaultAddReportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let context: ModelContext

    private let titleField = UITextField()
    private let typeField = UITextField()
    private let datePicker = UIDatePicker()
    private let imagePreview = UIImageView()
    private var selectedImages: [UIImage] = []

    init(context: ModelContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Report"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveReport)

        )
        navigationItem.rightBarButtonItem?.tintColor = .saanjhaSoftPink
        setupUI()
    }

    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        titleField.placeholder = "Title"
        typeField.placeholder = "Type (e.g. Scan / Report)"
        [titleField, typeField].forEach {
            $0.borderStyle = .roundedRect
            $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
            stack.addArrangedSubview($0)
        }

        datePicker.datePickerMode = .date
        stack.addArrangedSubview(datePicker)

        let imageBtn = UIButton(type: .system)
        imageBtn.setTitle("Add Images", for: .normal)
        imageBtn.tintColor = .saanjhaSoftPink
        imageBtn.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        stack.addArrangedSubview(imageBtn)

        imagePreview.backgroundColor = .secondarySystemBackground
        imagePreview.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imagePreview.contentMode = .scaleAspectFit
        stack.addArrangedSubview(imagePreview)
    }

    // MARK: - Image Picker
    @objc private func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        if let img = info[.originalImage] as? UIImage {
            selectedImages.append(img)
            imagePreview.image = img
        }
    }

    // MARK: - Save Report
    @objc private func saveReport() {
        let title = titleField.text ?? ""
        let type = typeField.text ?? "General"
        let date = datePicker.date

        // Save images to disk
        var imageNames: [String] = []

        for img in selectedImages {
            if let data = img.jpegData(compressionQuality: 0.8) {
                let id = UUID().uuidString + ".jpg"
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    .appendingPathComponent(id)
                try? data.write(to: url)
                imageNames.append(id)
            }
        }

        let report = VaultReport(
            title: title,
            reportType: type,
            reportDate: date,
            imageIdentifiers: imageNames,
            uploadDate: Date()
        )

        context.insert(report)
        try? context.save()
        NotificationCenter.default.post(name: .vaultDidUpdate, object: nil)

        dismiss(animated: true)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }
}
