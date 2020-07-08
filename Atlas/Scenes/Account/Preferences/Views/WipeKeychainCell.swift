//
//  WipeKeychainCell.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class WipeKeychainCell: UITableViewCell {
    private let stackView = UIStackView()
    private let descriptionLabel = UILabel(styling: .body)
    private let button = UIButton(type: .system)
    var action: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

private extension WipeKeychainCell {
    func setupViews() {
        self.selectionStyle = .none
        setupStackView()
        setupButton()
        setupDescriptionLabel()
//        stackView.addSpacer()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10.0
        
        setupStackViewConstraints()
    }

    func setupStackViewConstraints() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15.0)
        let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15.0)
        let top = stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15.0)
        let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -15.0)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupButton() {        
        button.setTitle("Wipe Keychain", for: .normal)
        button.addTarget(
            self,
            action: #selector(self.buttonTapped),
            for: .touchUpInside
        )
        
        stackView.addArrangedSubview(button)
        setupButtonConstraints()
    }
    
    func setupButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let height = button.heightAnchor.constraint(equalToConstant: 44.0)
        
        NSLayoutConstraint.activate([height])
    }
    
    func setupDescriptionLabel() {
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    @objc func buttonTapped() {
        action?()
    }
}

extension WipeKeychainCell {
    func configure(wiped: Bool?) {
        guard let wipeStatus = wiped else { return }
        
        if wipeStatus {
            descriptionLabel.text = "Successfully wiped Atlas' keychain."
        } else {
            descriptionLabel.text = "Invalid passphrase, contact the developer to ontain the valid passphrase."
        }
    }
}
