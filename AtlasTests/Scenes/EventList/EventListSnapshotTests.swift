//
//  EventListSnapshotTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 25/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import SnapshotTesting

class EventListSnapshotTests: XCTestCase {
    private var sut: EventListViewController!
    private var client: APIClientProtocol!
    private var service: EventService!
    private var presenter:EventListPresentationLogic!
    
    override func setUp() {
        super.setUp()
        client = AWSClient(appSyncClient: MockAPIClient())
        service = EventService(client: client)
        presenter = EventListPresenter()
        
//        record = true
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        service = nil
        client = nil
        super.tearDown()
    }
    
    func testEventListViewController_noEvents() {
        sut = EventListViewController()
        presenter.setup(viewController: sut)
        sut.setup(interactor: EventListInteractor(presenter: presenter, eventService: service))
        
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        sut.viewWillAppear(false)
        sut.viewDidAppear(false)
        assertSnapshot(matching: sut, as: .image(on: .iPhoneSe))
    }
}
