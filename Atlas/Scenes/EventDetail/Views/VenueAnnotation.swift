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
    private (set) var coordinate: CLLocationCoordinate2D
    
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
