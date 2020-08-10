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
