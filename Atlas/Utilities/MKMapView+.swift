//
//  MKMapView+.swift
//  Atlas
//
//  Created by Parvin Sital on 07/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import MapKit
extension MKMapView {
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
