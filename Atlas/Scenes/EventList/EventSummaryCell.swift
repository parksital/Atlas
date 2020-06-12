//
//  EventSummaryCell.swift
//  Atlas
//
//  Created by Parvin Sital on 10/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class EventSummaryCell: UITableViewCell {
    private let containerView = UIView()
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    private let eventTitleLabel = UILabel(styling: .title)
    private let venueLabel = UILabel(styling: .secondary)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EventSummaryCell {
    func setupViews() {
        setupStackViewConstraints()
        setupContainerViewConstraints()
        setupEventTitleLabel()
        setupVenueLabel()
        applyCardStyle()
    }
    
    func applyCardStyle() {
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOpacity = 0.2
    }
    
    func setupContainerViewConstraints() {
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let leading = containerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16.0)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        let top = containerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10.0)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupStackViewConstraints() {
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0)
        let trailing = stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0)
        let top = stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0)
        let bottom = stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.0)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupEventTitleLabel() {
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        eventTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        eventTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stackView.addArrangedSubview(eventTitleLabel)
    }
    
    func setupVenueLabel() {
        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        venueLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        venueLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.addArrangedSubview(venueLabel)
    }
}

extension EventSummaryCell {
    func setupEmtpy(withLocalizedString string: String) {
        eventTitleLabel.text = string
    }
    
    func setup(eventSummary: EventSummary) {
        eventTitleLabel.text = eventSummary.title
        venueLabel.text = eventSummary.venue
    }
}
