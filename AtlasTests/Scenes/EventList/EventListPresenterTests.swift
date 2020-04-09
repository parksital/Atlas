//
//  EventListPresenterTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 24/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class EventListPresenterTests: XCTestCase {
    var sut: EventListPresenter!
    
    override func setUp() {
        super.setUp()
        sut = EventListPresenter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitializationFailure() {
        XCTAssertNil(sut.viewController)
    }
    
    func testInitializationSuccess() {
        let spy = ViewControllerSpy()
        sut.viewController = spy
        XCTAssertNotNil(sut.viewController)
    }
    
    func testPresentEventResponse() {
        let spy = ViewControllerSpy()
        sut.viewController = spy
        sut.presentEventItems([])
        let result = spy.viewModel
        
        XCTAssertNotNil(result)
    }
    
    func testPresentEventEmptyResponse() {
        let spy = ViewControllerSpy()
        sut.viewController = spy
        
        sut.presentEventItems([])
        let result = spy.viewModel.eventCount
        
        XCTAssertEqual(0, result)
    }
}

extension EventListPresenterTests {
    private class ViewControllerSpy: EventListDisplayLogic  {
        var viewModel: EventList.ViewModel = .init()
        
        func displayViewModel(_ viewModel: EventList.ViewModel) { }
        func didSelectEvent() { }
        func displayError(_ error: Error) { }
        func setup(router: EventListRouterProtocol) { }
        func setup(interactor: EventListLogic) { }
    }
}
