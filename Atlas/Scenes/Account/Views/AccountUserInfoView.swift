//
//  AccountUserInfoView.swift
//  Atlas
//
//  Created by Parvin Sital on 19/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class AccountUserInfoView: UIView {
    private let stackView = UIStackView()
    private let firstNamelabel = UILabel()
    private let lastNameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension AccountUserInfoView {
    func setupViews() {
        setupStackView()
        setupFirstNameLabel()
        setupLastNameLabel()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.backgroundColor = .secondarySystemBackground
        
        setupStackViewConstraints()
    }
    
    func setupStackViewConstraints() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupFirstNameLabel() {
        firstNamelabel.applyStyling(.title)
        firstNamelabel.backgroundColor = .clear
        stackView.addArrangedSubview(firstNamelabel)
    }
    
    func setupLastNameLabel() {
        lastNameLabel.applyStyling(.title)
        lastNameLabel.backgroundColor = .clear
        stackView.addArrangedSubview(lastNameLabel)
    }
}

extension AccountUserInfoView {
    func setup(firstName: String, lastName: String) {
        self.firstNamelabel.text = firstName
        self.lastNameLabel.text = lastName
    }
}


