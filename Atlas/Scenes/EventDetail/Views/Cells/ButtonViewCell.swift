//
//  ButtonViewCell.swift
//  Atlas
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class ButtonViewCell: UICollectionViewCell {
//    private var buttonView = UIView()
    private var button = UIButton(type: .roundedRect)
    var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        setupButton()
    }
}

private extension ButtonViewCell {
    func setupButton() {
        button.setTitle(NSLocalizedString("buyTicket", comment: ""), for: .normal)
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
        
        let top = button.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor)
        let bottom = button.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        let center = button.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor)
        let height = button.heightAnchor.constraint(equalToConstant: 44.0)
        
        NSLayoutConstraint.activate([top, bottom, center, height])
    }
    
    @objc func buttonTapped() {
        action?()
    }
}

extension ButtonViewCell {
    func configure(buttonTitle: String) {
        button.setTitle(buttonTitle, for: .normal)
    }
}
