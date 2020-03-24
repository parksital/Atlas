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
        sut = EventListInteractor(eventService: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInteractor_initialized() {
        sut.eventService = MockEventService(shouldPass: false)
        
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.eventService, "eventService not initialized")
    }
    
    func testFetchEventsCalledFailure() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldPass: false)
        
        sut.fetchEvents()
        
        let result = spy.errorReceived as! NetworkError
        XCTAssertEqual(result, NetworkError.noEvents)
    }
    
    func testFetchEventsCalledSuccess() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldPass: true)
        
        sut.fetchEvents()
        let result = spy.eventsReceived
        let expectation = MockEventService.getFakeResponse(count: 5)
        
        XCTAssertEqual(expectation, result)
    }
    
    func testEventSelectionWithoutEvents() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldPass: false)
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
    
    func testEventSelectionSuccessful() {
        let spy = PresenterSpy()
        sut.presenter = spy
        sut.eventService = MockEventService(shouldPass: true)
        // grab third object
        let mock = MockEventService.getFakeResponse(count: 5)[2]

        let input = EventSummary(
            id: mock.id,
            title: mock.title,
            startDate: mock.startDate,
            venue: mock.venue
        )
        
        sut.fetchEvents()
        sut.didSelectEvent(input)
        
        XCTAssertTrue(spy.eventSelected)
    }
    
}

//MARK: - Helpers
extension EventListInteractorTests {
    private class MockEventService: EventService {
        var shouldPass: Bool = true
        
        init(shouldPass: Bool) {
            self.shouldPass = shouldPass
            super.init(client: nil)
        }
        
        override func fetchEventList(_ completion: @escaping (Result<[EventList.Response], Error>) -> Void) {
            if shouldPass {
                let data = MockEventService.getFakeResponse(count: 5)
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noEvents))
            }
        }
        
        static func getFakeResponse(count: Int) -> [EventList.Response] {
            var result: [EventList.Response] = []
            for i in 1...count {
                let summary = EventList.Response(
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
