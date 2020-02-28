//
//  EventServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 23/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
@testable import Atlas
class EventServiceTests: XCTestCase {
    var eventService: EventFetching!
    
    override func setUp() {
        super.setUp()
        eventService = EventService(client: MockAPIClient())
    }

    override func tearDown() {
        eventService = nil
        super.tearDown()
    }
    
    func testEventService_init() {
        XCTAssertNotNil(eventService)
    }
    
    func testEventService_client_init() {
        XCTAssertNotNil(eventService.client)
    }
    
    private class MockAPIClient: APIClient {
        func fetch() {
            // this function should fetch mock json
        }
    }
}
