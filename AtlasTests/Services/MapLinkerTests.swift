//
//  MapLinkerTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 10/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import MapKit

protocol URLOpening {
    func canOpenURL(_ url: URL) -> Bool
}

extension UIApplication: URLOpening { }
struct MockUIApplication: URLOpening {
    var authorizedLinks: [URL]
    func canOpenURL(_ url: URL) -> Bool {
        return authorizedLinks.contains(url)
    }
}

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

class MapLinkerTests: XCTestCase {
    private var sut: MapLinker!
    private var location: CLLocationCoordinate2D!
    
    private var appleURL: URL!
    private var googleURL: URL!
    private var wazeURL: URL!
    
    override func setUp() {
        super.setUp()
        location = CLLocationCoordinate2D(
            latitude: 1.0,
            longitude: 5.0
        )
        
        appleURL = URL(string: "https://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)")!
        
        googleURL = URL(string: "comgooglemaps://?daddr=\(location.latitude),\(location.longitude)&directionsmode=driving")!
        
        wazeURL = URL(string: "waze://?ll=\(location.latitude),\(location.longitude)&navigate=false")!
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLinkCreationForApple() {
        let expectation = appleURL
        let mockUIApplication = MockUIApplication(authorizedLinks: [])

        sut = MapLinker(location: location, urlOpener: mockUIApplication)
        let result = sut.url(forService: .apple)

        XCTAssertEqual(result, expectation)
    }
    
    func testLinkCreationForGoogle() {
        let expectation = googleURL
        let mockUIApplication = MockUIApplication(authorizedLinks: [])
        sut = MapLinker(location: location, urlOpener: mockUIApplication)
        let result = sut.url(forService: .google)
        XCTAssertEqual(result, expectation)
    }
    
    func testLinkCreationForWaze() {
        let expectation =  wazeURL
        let mockUIApplication = MockUIApplication(authorizedLinks: [])
        sut = MapLinker(location: location, urlOpener: mockUIApplication)
        let result = sut.url(forService: .waze)
        XCTAssertEqual(result, expectation)
    }
    
    func testListAllServices() {
        let mockUIApplication = MockUIApplication(authorizedLinks: [])
        sut = MapLinker(location: location, urlOpener: mockUIApplication)
        let expectation = [
            "appleMaps",
            "googleMaps",
            "waze"
        ]
        
        let result = sut.services
        XCTAssertEqual(result, expectation)
    }
    
    func testListAvailableServices_onlyApple() {
        let mockUIApplication = MockUIApplication(
            authorizedLinks: [appleURL]
        )
        
        sut = MapLinker(location: location, urlOpener: mockUIApplication)
        let result = sut.availableServices
        XCTAssertEqual(result, [.apple])
    }
    
    func testListAvailableServices_appleAndGoogle() {
        let mockUIApplication = MockUIApplication(
            authorizedLinks: [appleURL, googleURL]
        )
        
        sut = MapLinker(location: location, urlOpener: mockUIApplication)
        let result = sut.availableServices
        XCTAssertEqual(result, [.apple, .google])
    }
    
    func testListAvailableServices_appleGoogleWaze() {
        let mockUIApplication = MockUIApplication(
            authorizedLinks: [
                appleURL,
                googleURL,
                wazeURL
            ]
        )
        
        sut = MapLinker(location: location, urlOpener: mockUIApplication)
        let result = sut.availableServices
        XCTAssertEqual(result, [.apple, .google, .waze])
    }
}
