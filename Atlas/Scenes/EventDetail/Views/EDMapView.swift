//
//  EDMapView.swift
//  Atlas
//
//  Created by Parvin Sital on 11/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import MapKit

final class EDMapView: MKMapView {
    private let categories: [MKPointOfInterestCategory] = [
        .airport,
        .atm,
        .evCharger,
        .gasStation,
        .hotel,
        .museum,
        .park,
        .parking,
        .restaurant,
        .hospital,
        .police,
        .publicTransport,
        .stadium
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension EDMapView {
    func setup() {
        super.delegate = self
        self.mapType = .standard
        self.showsCompass = true
        self.isZoomEnabled = false
        self.isScrollEnabled = false
        self.isPitchEnabled = false
        self.isRotateEnabled = false
        let filter = MKPointOfInterestFilter(including: categories)
        self.pointOfInterestFilter = filter
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 30_000)
        self.setCameraZoomRange(zoomRange, animated: true)
    }
    
    func setBoundaryRegion(_ region: MKCoordinateRegion) {
        let output = MKCoordinateRegion(
            center: region.center,
            latitudinalMeters: 500,
            longitudinalMeters: 5000
        )
        self.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: output),
            animated: true
        )
    }
}

extension EDMapView {
    func zoomToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000.0,
        animated: Bool = false
    ) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        setRegion(region, animated: animated)
    }
}

extension EDMapView: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        marker.animatesWhenAdded = false
        marker.isEnabled = false
        marker.isSelected = true
        marker.titleVisibility = .visible
        marker.subtitleVisibility = .visible
        return marker
    }
}
