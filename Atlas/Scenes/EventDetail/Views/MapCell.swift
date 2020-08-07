//
//  MapCell.swift
//  Atlas
//
//  Created by Parvin Sital on 07/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit
import MapKit

final class MapCell: UICollectionViewCell {
    private let regionRadius: Double = 250.0
    private let containerView = UIView()
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

private extension MapCell {
    func setupViews() {
        setupContainerConstraints()
        setupMapView()
        applyRoundedCorners()
    }
    func setupContainerConstraints() {
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let leading = containerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16.0)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        let top = containerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16.0)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupMapView() {
        mapView.delegate = self
        containerView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let trailing = mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let top = mapView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let bottom = mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let height = mapView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        
        let centerX = mapView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        let centerY = mapView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        
        NSLayoutConstraint.activate([centerY, centerX, leading, trailing, top, bottom, height])
    }
    
    func applyRoundedCorners() {
        mapView.layer.cornerRadius = 22.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        containerView.layer.shadowRadius = 8.0
        containerView.layer.shadowOpacity = 0.2
    }
}

extension MapCell: MKMapViewDelegate { }

extension MapCell {
    func configure(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        mapView.zoomToLocation(location)
    }
}
