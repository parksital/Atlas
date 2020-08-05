//
//  EventDescriptionCell.swift
//  Atlas
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class EventDescriptionCell: UICollectionViewCell {
    private let headerLabel = UILabel(styling: .headline)
    private let descriptionLabel = UILabel(styling: .body)
    private var stackView = UIStackView()
    private var viewsToAdd: [UIView] {
        return [headerLabel, descriptionLabel]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        setupHeaderLabel()
        setupStackView()
    }
    
    func setupHeaderLabel() {
        headerLabel.text = NSLocalizedString("eventInformation", comment: "")
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        viewsToAdd.forEach({ [stackView] in stackView.addArrangedSubview($0) })
        setupStackViewConstraints()
    }
    
    func setupStackViewConstraints() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0)
        let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0)
        let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func configure(description: String?) {
        descriptionLabel.text = description
    }
}
