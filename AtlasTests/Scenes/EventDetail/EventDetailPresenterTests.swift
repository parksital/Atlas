//
//  EventDetailPresenterTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 12/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class EventDetailPresenterTests: XCTestCase {
    private var sut: EventDetailPresenter!
    private var spy: ViewControllerSpy!
    private var decoder: JSONDecoder!
    
    override func setUp() {
        super.setUp()
        sut = EventDetailPresenter()
        spy = ViewControllerSpy()
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        sut.setup(viewController: spy)
    }

    override func tearDown() {
        sut = nil
        spy = nil
        super.tearDown()
    }
    
    func testInitializationSuccess() {
        let result = sut.viewController
        XCTAssertNotNil(result)
    }
    
    func testEventTitlePresentation() {
        let title = "Howdy"
        sut.presentEventTitle(title: title)
        
        let result = spy.eventtitle
        XCTAssertNotNil(result)
        XCTAssertEqual(result, title)
    }
    
    func testEventPresentation() {
        // check eventByID.json for ID
        let eventID = "a313dd4e-a68c-4240-957a-c9b9dba85ca0"
        let data = MockAPIClient.getDataFromFile(
            fileName: "eventByID",
            extension: "json"
        )
        let event = try! decoder.decode(GetEvent.self, from: data).event
        
        sut.presentEvent(event)
        
        let result = spy.items[0].event.id
        XCTAssertEqual(result, eventID)
    }
    
    func testEventPresentationWithoutDescription() {
        let data = MockAPIClient.getDataFromFile(
            fileName: "eventByID-empty",
            extension: "json"
        )
        let event = try! decoder.decode(GetEvent.self, from: data).event
        
        sut.presentEvent(event)
        let result = spy.items[0].event.description
        XCTAssertEqual(result, "")
    }
    
    func testEventViewModelWithoutArtists() {
        let data = MockAPIClient.getDataFromFile(
            fileName: "eventByID-empty",
            extension: "json"
        )
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let event = try! decoder.decode(GetEvent.self, from: data).event
        
        sut.presentEvent(event)
        let result = spy.items[0].event.artists
        XCTAssertEqual(result, [])
    }
    
    func testEventDateFormatting() {
        let data = MockAPIClient.getDataFromFile(
            fileName: "eventByID-empty",
            extension: "json"
        )
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let event = try! decoder.decode(GetEvent.self, from: data).event
        
        sut.presentEvent(event)
        
        let result = spy.items[0].event.startDate
        let expectation = "Thursday, 21 January 2021 at 23:00"
        XCTAssertEqual(result, expectation)
    }
}

extension EventDetailPresenterTests {
    private class ViewControllerSpy: EventDetailDisplayLogic {
        var eventtitle: String?
        var items: [EventDetailItem] = []
        
        func displayEventTitle(_ title: String) {
            eventtitle = title
        }
        
        func displayEventDetailItems(_ items: [EventDetailItem]) {
            self.items = items
        }
        
        func displayBuyTicketScene() { }
        func setup(interactor: EventDetailInteraction) { }
        func setup(router: EventDetailRouterProtocol) { }
    }
}
