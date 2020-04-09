//
//  EventListInteractorTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 17/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class EventListInteractorTests: XCTestCase {
    private var sut: EventListInteractor!
    private var spy: PresenterSpy!
    
    override func setUp() {
        super.setUp()
        let client = AWSClient(appSyncClient: MockAPIClient())
        spy = PresenterSpy()
        sut = EventListInteractor(presenter: spy, eventService: EventService(client: client)
        )
    }

    override func tearDown() {
        sut = nil
        spy = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
    }
    
    func testServiceInitialization() {
        XCTAssertNotNil(sut.eventService)
    }
    
    func testfPresenterInitialization() {
        XCTAssertNotNil(sut.presenter)
    }
    
    func testFetchEventsCalledSuccess() {
        sut.fetchEvents()
        let result = spy.eventsReceived.count
        let expectation = 4
        
        XCTAssertEqual(expectation, result)
    }
    
    func testEventSelectionWithoutEvents() {
        let fake = EventSummary(
            id: "uid",
            title: "title",
            startDate: Date(),
            venue: "venue"
        )
        
        sut.didSelectEvent(fake)
        
        let result = spy.errorReceived as! NetworkError
        
        XCTAssertEqual(result, NetworkError.generic)
    }
    
    func testEventSelectionSuccess() {
        let selectedEvent = EventSummary(
            id: "5a7e9ed7-f2f1-4d46-81f0-c3019910da8f",
            title: "doesn't matter",
            startDate: Date(),
            venue: "doesnt matter"
        )
        
        sut.fetchEvents()
        sut.didSelectEvent(selectedEvent)
        
        let result = spy.eventSelected
        XCTAssertTrue(result)
    }
}

//MARK: - Helpers
extension EventListInteractorTests {
    private class PresenterSpy: EventListPresentationLogic {
        var errorReceived: Error?
        var eventsReceived: [EventItem] = []
        var eventSelected: Bool = false
        
        func setup(viewController: EventListDisplayLogic) { }
        func presentEventItems(_ eventItems: [EventItem]) {
            eventsReceived = eventItems
        }
        func didSelectEvent() {
            eventSelected = true
        }
        func presentError(_ error: Error) {
            errorReceived = error
        }
    }
}
