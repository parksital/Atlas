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
        self.mapType = .standard
        self.showsCompass = true
        self.isZoomEnabled = false
        self.isScrollEnabled = false
        self.isPitchEnabled = false
        self.isRotateEnabled = false
        let filter = MKPointOfInterestFilter(including: categories)
        self.pointOfInterestFilter = filter
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
