//
//  ArtistContainerCell.swift
//  Atlas
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class ArtistContainerCell: UICollectionViewCell {
    private let headerLabel = UILabel(styling: .headline)
    private var stackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView = UIStackView()
    }
}

private extension ArtistContainerCell {
    func setupViews() {
        setupHeaderLabel()
        setupStackView()
    }
    
    func setupHeaderLabel() {
        headerLabel.text = NSLocalizedString("artists", comment: "")
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.addArrangedSubview(headerLabel)
        
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
}

extension ArtistContainerCell {
    func configure(withArtists artists: [String]) {
        artists.forEach({ [weak self] artist in
            let label = UILabel(styling: .body)
            label.text = artist
            self?.stackView.addArrangedSubview(label)
        })
    }
}
