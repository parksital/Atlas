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
    private let mapView = EDMapView()
    
    private var tapGesture: UITapGestureRecognizer!
    var openWithAction: (() -> Void)?
    
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
        setupTapGesture()
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
        mapView.addGestureRecognizer(tapGesture)
        setupMapViewConstraints()
    }
    
    func setupMapViewConstraints() {
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
    
    func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.mapTapped)
        )
        tapGesture.delegate = self
    }
    
    @objc func mapTapped() {
        openWithAction?()
    }
}

extension MapCell: UIGestureRecognizerDelegate { }

extension MapCell {
    func configure(event: EventDetail.ViewModel) {
        let location = event.location
        
        let annotation = VenueAnnotation(
            coordinate: location.coordinate,
            title: event.venue,
            subtitle: event.address
        )
        
        mapView.zoomToLocation(location, regionRadius: regionRadius)
        mapView.addAnnotation(annotation)
    }
}
