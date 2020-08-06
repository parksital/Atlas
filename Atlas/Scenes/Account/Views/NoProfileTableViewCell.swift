//
//  NoProfileTableViewCell.swift
//  Atlas
//
//  Created by Parvin Sital on 22/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class NoProfileTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let mainLabel = UILabel()
    private let button = UIButton(type: .system)
    var action: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NoProfileTableViewCell {
    func setupViews() {
        self.selectionStyle = .none
        setupStackView()
        setupLabel()
        setupButton()
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
    
    func setupLabel() {
        mainLabel.applyStyling(.primary)
        mainLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        stackView.addArrangedSubview(mainLabel)
    }
    
    func setupButton() {
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(
            top: 13.0,
            left: 15.0,
            bottom: 13.0,
            right: 15.0
        )
        
        button.addTarget(
            self,
            action: #selector(self.buttonTapped),
            for: .touchUpInside
        )
        
        stackView.addArrangedSubview(button)
    }
    
    @objc func buttonTapped() {
        action?()
    }
}

extension NoProfileTableViewCell {
    func configure(mainLabelText: String, buttonTitle: String) {
        mainLabel.text = mainLabelText
        button.setTitle(buttonTitle, for: .normal)
    }
}
