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
    
    func testDateFormatting() {
        // Saturday, January 25, 2020 3:00:00 PM
        let expectation = "2020-01-25T15:00:00Z"
        
        let input = Date(timeIntervalSince1970: 1579964400)
        let result = sut.formatDate(input)
        
        XCTAssertEqual(expectation, result)
    }
}
