//
//  UserProfileTableViewCell.swift
//  Atlas
//
//  Created by Parvin Sital on 22/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class UserProfileTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let firstNamelabel = UILabel()
    private let lastNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: .default,
            reuseIdentifier: String(describing: UserProfileTableViewCell.self)
        )
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

private extension UserProfileTableViewCell {
    func setupViews() {
        self.selectionStyle = .none
    
        setupContainerViewConstraints()
        setupStackView()
        setupFirstNameLabel()
        setupLastNameLabel()
//        applyCardStyle()
    }
    
    func applyCardStyle() {
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOpacity = 0.2
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        setupStackViewConstraints()
    }
    
    func setupContainerViewConstraints() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let leading = containerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        let top = containerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10.0)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupStackViewConstraints() {
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.0)
        let trailing = stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.0)
        let top = stackView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 15.0)
        let bottom = stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15.0)
        
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

extension UserProfileTableViewCell {
    func setup(firstName: String, lastName: String) {
        self.firstNamelabel.text = firstName
        self.lastNameLabel.text = lastName
    }
}

