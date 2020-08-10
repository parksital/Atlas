//
//  MapLinker.swift
//  Atlas
//
//  Created by Parvin Sital on 10/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit
import MapKit

struct MapLinker {
    enum Service: String {
        case apple = "appleMaps"
        case google = "googleMaps"
        case waze
        
        private var scheme: String {
            switch self {
            case .apple: return "https"
            case .google: return "comgooglemaps"
            case .waze: return "waze"
            }
        }
        
        private var host: String {
            switch self {
            case .apple: return "maps.apple.com"
            case .google: return ""
            case .waze: return ""
            }
        }
        
        private var path: String {
            switch self {
            case .apple: return "/"
            case .google: return ""
            case .waze: return ""
            }
        }
        
        func queryItems(latitude: Double, longitude: Double) -> [URLQueryItem] {
            var output: [URLQueryItem] = []
            switch self {
            case .apple:
                output.append(URLQueryItem(name: "daddr", value: "\(latitude),\(longitude)"))
            case .google:
                output.append(contentsOf: [
                    URLQueryItem(name: "daddr", value: "\(latitude),\(longitude)"),
                    URLQueryItem(name: "directionsmode", value: "driving")
                ])
            case .waze:
                output.append(contentsOf: [
                    URLQueryItem(name: "ll", value: "\(latitude),\(longitude)"),
                    URLQueryItem(name: "navigate", value: "false")
                ])
            }
            
            return output
        }
        
        func url(latitude: Double, longitude: Double) -> URL {
            var components = URLComponents()
            components.scheme = self.scheme
            components.host = self.host
            components.path = self.path
            components.queryItems = self.queryItems(
                latitude: latitude,
                longitude: longitude
            )
            
            return components.url!
        }
    }
    
    let location: CLLocationCoordinate2D
    let urlOpener: URLOpening
    
    init(
        location: CLLocationCoordinate2D,
        urlOpener: URLOpening = UIApplication.shared
    ) {
        self.urlOpener = urlOpener
        self.location = location
    }
    
    var services: [String] {
        Service.allCases
            .map({ $0.rawValue })
    }
    
    var availableServices: [Service] {
        return Service.allCases
            .filter({ value in
                let url = value.url(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
                return urlOpener.canOpenURL(url)
            })
    }
    
    func url(forService service: Service) -> URL? {
        service.url(
            latitude: location.latitude,
            longitude: location.longitude
        )
    }
}

extension MapLinker.Service: CaseIterable { }
