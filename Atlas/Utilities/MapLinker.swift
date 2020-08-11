//
//  MapLinker.swift
//  Atlas
//
//  Created by Parvin Sital on 10/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

struct MapLinker {
    enum Service: String {
        case appleMaps
        case googleMaps
        case wazeNavigation
        
        private var scheme: String {
            switch self {
            case .appleMaps: return "https"
            case .googleMaps: return "comgooglemaps"
            case .wazeNavigation: return "waze"
            }
        }
        
        private var host: String {
            switch self {
            case .appleMaps: return "maps.apple.com"
            case .googleMaps: return ""
            case .wazeNavigation: return ""
            }
        }
        
        private var path: String {
            switch self {
            case .appleMaps: return "/"
            case .googleMaps: return ""
            case .wazeNavigation: return ""
            }
        }
        
        func queryItems(latitude: Double, longitude: Double) -> [URLQueryItem] {
            var output: [URLQueryItem] = []
            switch self {
            case .appleMaps:
                output.append(URLQueryItem(name: "daddr", value: "\(latitude),\(longitude)"))
            case .googleMaps:
                output.append(contentsOf: [
                    URLQueryItem(name: "daddr", value: "\(latitude),\(longitude)"),
                    URLQueryItem(name: "directionsmode", value: "driving")
                ])
            case .wazeNavigation:
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
    
    let latitude: Double
    let longitude: Double
    let urlOpener: URLOpening
    
    init(
        latitude: Double,
        longitude: Double,
        urlOpener: URLOpening = UIApplication.shared
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.urlOpener = urlOpener
    }
    
    var services: [String] {
        Service.allCases
            .map({ $0.rawValue })
    }
    
    var availableServices: [Service] {
        return Service.allCases
            .filter({ value in
                let url = value.url(
                    latitude: latitude,
                    longitude: longitude
                )
                return urlOpener.canOpenURL(url)
            })
    }
    
    func openURL(forService service: Service) {
        let url = service.url(
            latitude: latitude,
            longitude: longitude
        )
        
        urlOpener.open(url, completion: nil)
    }
    
    func url(forService service: Service) -> URL? {
        service.url(
            latitude: latitude,
            longitude: longitude
        )
    }
}

extension MapLinker.Service: CaseIterable { }
