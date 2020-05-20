//
//  EmptyAccountView.swift
//  Atlas
//
//  Created by Parvin Sital on 20/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class EmptyAccountView: UIView {
    private let stackView = UIStackView()
    private let mainLabel = UILabel()
    private let button = UIButton(type: .system)
    var action: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyAccountView {
    func setupViews() {
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
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupLabel() {
        mainLabel.applyStyling(.primary)
        stackView.addArrangedSubview(mainLabel)
    }
    
    func setupButton() {
        button.setTitle("Get started!", for: .normal)
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

extension EmptyAccountView {
    func configure() {
        mainLabel.text = "You're not signed up"
    }
}
