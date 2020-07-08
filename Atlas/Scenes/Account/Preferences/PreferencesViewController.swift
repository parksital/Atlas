//
//  PreferencesViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class PreferencesViewController: UIViewController {
    private let wipeKeychainButton = UIButton(type: .roundedRect)
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension PreferencesViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupStackView()
        setupWipeKeychainButton()
    }
    
    func setupNavigation() {
        navigationItem.title = "Preferences"
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10.0
        
        setupStackViewConstraints()
    }
    
    func setupStackViewConstraints() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15.0)
        let trailing = stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.0)
        let top = stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15.0)
        
        NSLayoutConstraint.activate([leading, trailing, top])
    }
    
    func setupWipeKeychainButton() {
        wipeKeychainButton.setTitle("Wipe Keychain", for: .normal)
        wipeKeychainButton.tintColor = .systemRed
        wipeKeychainButton.addTarget(
            self,
            action: #selector(self.wipeKeychain),
            for: .touchUpInside
        )
        
        stackView.addArrangedSubview(wipeKeychainButton)
    }
    
    @objc func wipeKeychain() {
        DispatchQueue.global(qos: .utility).async {
            _ = KeychainWrapper.standard.removeAllKeys()
        }
    }
}
