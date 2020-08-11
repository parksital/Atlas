//
//  VenueAnnotation.swift
//  Atlas
//
//  Created by Parvin Sital on 07/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import MapKit

final class VenueAnnotation: NSObject, MKAnnotation {
    private (set) var title: String?
    private (set) var subtitle: String?
    private (set) var coordinate: CLLocationCoordinate2D
    
    
    init(
        coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String? = nil
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
