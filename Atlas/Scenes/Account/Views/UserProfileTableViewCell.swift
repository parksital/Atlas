//
//  UserProfileTableViewCell.swift
//  Atlas
//
//  Created by Parvin Sital on 22/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class UserProfileTableViewCell: UITableViewCell {
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
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let top = stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
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

