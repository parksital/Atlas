//
//  WipeKeychainCell.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class WipeKeychainCell: UITableViewCell {
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

private extension WipeKeychainCell {
    func setupViews() {
        self.selectionStyle = .none
        setupButton()
    }
    
    func setupButton() {
        button.setTitle("Wipe Keychain", for: .normal)
        button.tintColor = .systemRed
        button.addTarget(
            self,
            action: #selector(self.buttonTapped),
            for: .touchUpInside
        )
        
        setupButtonConstraints()
    }
    
    func setupButtonConstraints() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = button.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        let top = button.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        let bottom = button.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        let height = button.heightAnchor.constraint(equalToConstant: 44.0)
        
        NSLayoutConstraint.activate([leading, top, bottom, height])
    }
    
    @objc func buttonTapped() {
        action?()
    }
}

extension WipeKeychainCell {
    func configure() {
        
    }
}
