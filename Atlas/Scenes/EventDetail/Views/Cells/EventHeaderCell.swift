//
//  EventHeaderCell.swift
//  Atlas
//
//  Created by Parvin Sital on 30/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//
import UIKit

final class EventHeaderCell: UICollectionViewCell {
    private let stackView = UIStackView()
    private let venueLabel = UILabel(styling: .title)
    private let dateTimeLabel = UILabel(styling: .body)
    private var viewsToAdd: [UIView] {
        return [venueLabel, dateTimeLabel]
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
        setupStackView()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
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
    
    func configure(venueName: String?, dateTime: String?) {
        venueLabel.text = venueName
        dateTimeLabel.text = dateTime
    }
}
