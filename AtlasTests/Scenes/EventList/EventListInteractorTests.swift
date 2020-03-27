//
//  EventListInteractorTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 17/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class EventListInteractorTests: XCTestCase {
    var sut: EventListInteractor!
    
    override func setUp() {
        super.setUp()
        sut = EventListInteractor(eventService: EventService())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
    }
    
    func testServiceInitialization() {
        XCTAssertNotNil(sut.eventService)
    }
    
    func testfPresenterInitialization() {
        let spy = PresenterSpy()
        sut.presenter = spy
        XCTAssertNotNil(sut.presenter)
    }
    
    func testFetchEventsCalledSuccess() {
        let spy = PresenterSpy()
        sut.presenter = spy
        
        sut.fetchEvents()
        let result = spy.eventsReceived.count
        let expectation = 4
        
        XCTAssertEqual(expectation, result)
    }
    
    func testEventSelectionWithoutEvents() {
        let spy = PresenterSpy()
        sut.presenter = spy

        let fake = EventSummary(
            id: "uid",
            title: "title",
            startDate: Date(),
            venue: "venue"
        )
        
        sut.fetchEvents()
        sut.didSelectEvent(fake)
        
        let result = spy.errorReceived as! NetworkError
        
        XCTAssertEqual(result, NetworkError.generic)
    }
}

//MARK: - Helpers
extension EventListInteractorTests {
    private class PresenterSpy: EventListPresentationLogic {
        var errorReceived: Error?
        var eventsReceived: [EventList.Response] = []
        var eventSelected: Bool = false
        
        func presentEventResponse(_ response: [EventList.Response]) {
            eventsReceived = response
        }
        
        func didSelectEvent() {
            eventSelected = true
        }
        func presentError(_ error: Error) {
            errorReceived = error
        }
    }
}
