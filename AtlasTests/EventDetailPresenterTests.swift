//
//  EventDetailPresenterTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 12/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class EventDetailPresenterTests: XCTestCase {
    var sut: EventDetailPresenter!
    
    override func setUp() {
        super.setUp()
        sut = EventDetailPresenter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testViewModelCreation() {
        // "January 25, 2020 at 4:00 PM"
        // "January 25, 2020 at 7:00 PM"
        
        // timestamp start: 1579964400
        // timestamp end: 1579975200
        
        let uid = UUID().uuidString
        
        let response = EventDetail.Response(
            id: uid,
            title: "Mock Event Title",
            startDate: Date(timeIntervalSince1970: 1579964400),
            endDate: Date(timeIntervalSince1970: 1579975200),
            venue: "Mock Venue Name",
            description: "mock event description",
            artists: []
        )
        
        let expectation = EventDetail.ViewModel(
            id: uid,
            title: "Mock Event Title",
            startDate: "January 25, 2020 at 4:00 PM",
            venue: "Mock Venue Name",
            description: "Mock Event Description.",
            artists: []
        )
        
        let result = sut.getViewModelForResponse(response)
        
        XCTAssertEqual(expectation.description!, result.description!)
    }
    
    func testDateFormatting_intervalSince1970_startDate() {
        // Saturday, January 25, 2020 3:00:00 PM
        // "2020-01-25T15:00:00Z"
        // timestamp: 1579964400
        let expectation = "Saturday, January 25, 2020 at 4:00 PM"
        
        let input = Date(timeIntervalSince1970: 1579964400)
        let result = sut.formatDate(input)
        
        XCTAssertEqual(expectation, result)
    }
    
    func testDateFormatting_intervalSince1970_endDate() {
        // "January 25, 2020 at 7:00 PM"
        // timestamp: 1579975200
        
        let expectation = "Saturday, January 25, 2020 at 7:00 PM"
        
        let input = Date(timeIntervalSince1970: 1579975200)
        let result = sut.formatDate(input)
        
        XCTAssertEqual(expectation, result)
    }
    
    func testDateFormatting_zeroIntervalSince1970() {
        // "1970-01-01T00:00:00Z"
        // timestamp: 0
        let expectation = "Thursday, January 1, 1970 at 1:00 AM"

        let input = Date(timeIntervalSince1970: 0)
        let result = sut.formatDate(input)
        
        XCTAssertEqual(expectation, result)
    }
    
    func testCustomFormatting() {
        // Saturday, January 25, 2020 3:00:00 PM
        // "2020-01-25T15:00:00Z"
        // timestamp: 1579964400
        
        let expectation = "4:00 PM"
        
        let input = Date(timeIntervalSince1970: 1579964400)
        let result = input.formatted(using: { date in
            let formatter = DateFormatter()
            formatter.locale = .init(identifier: "en_US")
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: date)
        })
        
        XCTAssertEqual(expectation, result)
    }
}
