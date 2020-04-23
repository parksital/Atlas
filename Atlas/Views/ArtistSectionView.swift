//
//  ArtistSectionView.swift
//  Atlas
//
//  Created by Parvin Sital on 17/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class ArtistSectionView: UIView {
    private let cornerRadius: CGFloat = 8.0
    private let fillColor: CGColor = UIColor.white.cgColor
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.applyStyling(.headline)
        label.text = "Artists"
        return label
    }()
    
    private var artists: [String] = []
    
    init(artists: [String]) {
        super.init(frame: .zero)
        self.artists = artists
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
    }
}

private extension ArtistSectionView {
    func setup() {
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(headerLabel)
        addArtistLabelsForArtists(artists)
        setupStackViewConstraints()
    }
    
    func addShadow() {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = fillColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 5
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func addArtistLabelsForArtists(_ artists: [String]) {
        artists.forEach { [weak self] in
            guard let self = self else { return }
            let label = self.getLabelForArtist($0)
            self.stackView.addArrangedSubview(label)
        }
    }
    
    func getLabelForArtist(_ artist: String) -> UILabel {
        let label = UILabel()
        label.applyStyling(.body)
        label.text = artist
        return label
    }
    
    func setupStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let top = stackView.topAnchor.constraint(equalTo: self.topAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        NSLayoutConstraint.activate([leading, top, trailing, bottom])
    }
}
