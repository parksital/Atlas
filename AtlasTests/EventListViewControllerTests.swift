//
//  EventListViewControllerTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 01/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
@testable import Atlas
class EventListViewControllerTests: XCTestCase {
    var sut: EventListViewOutputProtocol!
    
    override func setUp() {
        super.setUp()
        sut = EventListViewControllerSpy()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testShouldCallFetchEventsWhenViewIsLoaded() {
        
    }
    
    private class EventListViewControllerSpy: EventListViewOutputProtocol {
        var fetchEventsCalled: Bool = false
        
        func fetchEvents() {
            fetchEventsCalled = true
        }
    }
}
