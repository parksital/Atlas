//
//  EventListInteractorTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 17/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
class EventListInteractorTests: XCTestCase {
    private class MockEventService: EventService {
        var shouldFail: Bool = true
        
        init(shouldFail: Bool) {
            self.shouldFail = shouldFail
        }
        
        override func fetchEventsSummarized(_ completion: @escaping (Result<[EventSummary], Error>) -> Void) {
            
            if shouldFail {
                completion(.failure(NetworkError.noEvents))
            } else {
                let data = MockEventService.getFakeSummaries(count: 5)
                completion(.success(data))
            }
        }
        
        static func getFakeSummaries(count: Int) -> [EventSummary] {
            var result: [EventSummary] = []
            for i in 1...count {
                let summary = EventSummary(
                    id: String(i),
                    title: "Mock title \(i)",
                    startDate: Date(timeIntervalSince1970: TimeInterval(i)),
                    venue: "Venue name \(i)"
                )
                
                result.append(summary)
            }
            return result
        }
    }
    
    private class PresenterSpy: EventListPresentationLogic {
        var errorReceived: Error?
        var eventsReceived: [EventSummary] = []
        var eventSelected: EventSummary?
        
        func presentEvents(_ events: [EventSummary]) {
            eventsReceived = events
        }
        
        func didSelectEvent(_ event: EventSummary) {
            eventSelected = event
        }
        
        func presentError(_ error: Error) {
            errorReceived = error
        }
    }
    
    var sut: EventListInteractor!
    
    override func setUp() {
        super.setUp()
        sut = EventListInteractor()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInteractor_initialized() {
        sut.eventService = MockEventService(shouldFail: true)
        
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.eventService, "eventService not initialized")
    }
    
    func testFetchEventsCalledFailure() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldFail: true)
        
        sut.fetchEvents()
        
        let result = spy.errorReceived as! NetworkError
        XCTAssertEqual(result, NetworkError.noEvents)
    }
    
    func testFetchEventsCalledSuccess() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldFail: false)
        
        sut.fetchEvents()
        let result = spy.eventsReceived
        let expectation = MockEventService.getFakeSummaries(count: 5)
        
        XCTAssertEqual(expectation, result)
    }
    
    func testEventSelectedOutOfBoundsFailure() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldFail: true)
        
        sut.fetchEvents() // WILL FAIL
        sut.didSelectEvent(atIndex: 2)
        
        let result = spy.errorReceived as! NetworkError
        XCTAssertEqual(result, NetworkError.generic)
    }
    
    func testEventSelectedSuccess() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldFail: false)
        
        sut.fetchEvents()
        sut.didSelectEvent(atIndex: 2)
        
        let events = MockEventService.getFakeSummaries(count: 5)
        let expectation = events[2]
        let result = spy.eventSelected
        XCTAssertEqual(result, expectation)
    }
}
