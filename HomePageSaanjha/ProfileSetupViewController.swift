//
//  ProfileSetupViewController.swift
//  HomePageSaanjha
//
//  Created by user@99 on 27/11/25.
//
import UIKit

class ProfileSetupViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "profile_background")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's get started"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tell us about yourself"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "first name"
        tf.borderStyle = .none
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "last name"
        tf.borderStyle = .none
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "phone number"
        tf.borderStyle = .none
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        tf.leftViewMode = .always
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let altPhoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "alternative phone"
        tf.borderStyle = .none
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        tf.leftViewMode = .always
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "Going to be..."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let motherButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Mother", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor(red: 1.0, green: 0.53, blue: 0.69, alpha: 1.0).cgColor
        btn.setTitleColor(UIColor(red: 1.0, green: 0.53, blue: 0.69, alpha: 1.0), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let fatherButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Father", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
        btn.setTitleColor(UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.backgroundColor = UIColor(red: 1.0, green: 0.53, blue: 0.69, alpha: 1.0)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var selectedRole: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .saanjhaLightPink
        
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(altPhoneTextField)
        contentView.addSubview(roleLabel)
        contentView.addSubview(motherButton)
        contentView.addSubview(fatherButton)
        contentView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            // Background
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            // First Name
            firstNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Last Name
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Phone
            phoneTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Alt Phone
            altPhoneTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
            altPhoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            altPhoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            altPhoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Role Label
            roleLabel.topAnchor.constraint(equalTo: altPhoneTextField.bottomAnchor, constant: 30),
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            // Mother Button
            motherButton.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            motherButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            motherButton.widthAnchor.constraint(equalToConstant: 120),
            motherButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Father Button
            fatherButton.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            fatherButton.leadingAnchor.constraint(equalTo: motherButton.trailingAnchor, constant: 16),
            fatherButton.widthAnchor.constraint(equalToConstant: 120),
            fatherButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Continue Button
            continueButton.topAnchor.constraint(equalTo: motherButton.bottomAnchor, constant: 40),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        motherButton.addTarget(self, action: #selector(motherTapped), for: .touchUpInside)
        fatherButton.addTarget(self, action: #selector(fatherTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    private func updateRoleSelection(role: String) {
        selectedRole = role
        
        if role == "mother" {
            motherButton.backgroundColor = UIColor(red: 1.0, green: 0.53, blue: 0.69, alpha: 1.0)
            motherButton.setTitleColor(.white, for: .normal)
            motherButton.layer.borderColor = UIColor.clear.cgColor
            
            fatherButton.backgroundColor = .clear
            fatherButton.setTitleColor(UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0), for: .normal)
            fatherButton.layer.borderColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
        } else {
            fatherButton.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)
            fatherButton.setTitleColor(.white, for: .normal)
            fatherButton.layer.borderColor = UIColor.clear.cgColor
            
            motherButton.backgroundColor = .clear
            motherButton.setTitleColor(UIColor(red: 1.0, green: 0.53, blue: 0.69, alpha: 1.0), for: .normal)
            motherButton.layer.borderColor = UIColor(red: 1.0, green: 0.53, blue: 0.69, alpha: 1.0).cgColor
        }
    }
    
    // MARK: - Actions
    @objc private func motherTapped() {
        updateRoleSelection(role: "mother")
    }
    
    @objc private func fatherTapped() {
        updateRoleSelection(role: "father")
    }
    
    @objc private func continueTapped() {
        // TODO: validate/save profile

        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate else { return }

        let tabBar = sceneDelegate.makeMainTabBar()
        sceneDelegate.window?.rootViewController = tabBar
        sceneDelegate.window?.makeKeyAndVisible()
    }

}

