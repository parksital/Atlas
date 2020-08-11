//
//  MapLinkerTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 10/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import MapKit

class MapLinkerTests: XCTestCase {
    private var sut: MapLinker!
    private var latitude: Double = 1.0
    private var longitude: Double = 5.0
    
    private var appleURL: URL!
    private var googleURL: URL!
    private var wazeURL: URL!
    
    override func setUp() {
        super.setUp()
        appleURL = URL(string: "https://maps.apple.com/?daddr=\(latitude),\(longitude)")!
        
        googleURL = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving")!
        
        wazeURL = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=false")!
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLinkCreationForApple() {
        let expectation = appleURL
        let mockUIApplication = MockUIApplication(authorizedLinks: [])

        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        let result = sut.url(forService: .appleMaps)

        XCTAssertEqual(result, expectation)
    }
    
    func testLinkCreationForGoogle() {
        let expectation = googleURL
        let mockUIApplication = MockUIApplication(authorizedLinks: [])
        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        
        let result = sut.url(forService: .googleMaps)
        XCTAssertEqual(result, expectation)
    }
    
    func testLinkCreationForWaze() {
        let expectation =  wazeURL
        let mockUIApplication = MockUIApplication(authorizedLinks: [])
        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        let result = sut.url(forService: .wazeNavigation)
        XCTAssertEqual(result, expectation)
    }
    
    func testListAllServices() {
        let mockUIApplication = MockUIApplication(authorizedLinks: [])
        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        let expectation = MapLinker.Service.allCases
            .map({ $0.rawValue })
        
        let result = sut.services
        XCTAssertEqual(result, expectation)
    }
    
    func testListAvailableServices_onlyApple() {
        let mockUIApplication = MockUIApplication(
            authorizedLinks: [appleURL]
        )
        
        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        let result = sut.availableServices
        XCTAssertEqual(result, [.appleMaps])
    }
    
    func testListAvailableServices_appleAndGoogle() {
        let mockUIApplication = MockUIApplication(
            authorizedLinks: [appleURL, googleURL]
        )
        
        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        let result = sut.availableServices
        XCTAssertEqual(result, [.appleMaps, .googleMaps])
    }
    
    func testListAvailableServices_appleGoogleWaze() {
        let mockUIApplication = MockUIApplication(
            authorizedLinks: [
                appleURL,
                googleURL,
                wazeURL
            ]
        )
        
        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        let result = sut.availableServices
        XCTAssertEqual(result, [.appleMaps, .googleMaps, .wazeNavigation])
    }
    
    func testOpenLinkCalled() {
        let mockUIApplication = MockUIApplication(
            authorizedLinks: [
                appleURL,
                googleURL,
                wazeURL
            ]
        )
        
        sut = MapLinker(
            latitude: latitude,
            longitude: longitude,
            urlOpener: mockUIApplication
        )
        
        sut.openURL(forService: .appleMaps)
        XCTAssertEqual(mockUIApplication.openURLCalledCount, 1)
    }
}
