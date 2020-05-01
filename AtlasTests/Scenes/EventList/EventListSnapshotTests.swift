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
    private var presenter: EventListPresentationLogic!
    
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
    
//    func testEventListViewController_noEvents() {
//        sut = EventListViewController()
//        // don't set up the presenter
//        sut.setup(interactor: EventListInteractor(presenter: presenter, eventService: service))
//        let vc = UINavigationController(rootViewController: sut)
//        assertSnapshots(matching: vc, as: [
//            .wait(for: 0.5, on: .image(on: .iPhone8))
//        ])
//    }
//    
//    func testEventListViewController_noEvents_dark() {
//        sut = EventListViewController()
//        // don't set up the presenter
//        sut.setup(interactor: EventListInteractor(presenter: presenter, eventService: service))
//        let vc = UINavigationController(rootViewController: sut)
//        vc.overrideUserInterfaceStyle = .dark
//        assertSnapshots(matching: vc, as: [
//            .wait(for: 0.5, on: .image(on: .iPhone8))
//        ])
//    }
//    
//    func testEventListViewController_events() {
//        sut = EventListViewController()
//        presenter.setup(viewController: sut)
//        sut.setup(interactor: EventListInteractor(presenter: presenter, eventService: service))
//        let vc = UINavigationController(rootViewController: sut)
//        assertSnapshots(matching: vc, as: [
//            .wait(for: 0.5, on: .image(on: .iPhone8))
//        ])
//    }
//    
//    func testEventListViewController_events_dark() {
//        sut = EventListViewController()
//        presenter.setup(viewController: sut)
//        sut.setup(interactor: EventListInteractor(presenter: presenter, eventService: service))
//        let vc = UINavigationController(rootViewController: sut)
//        vc.overrideUserInterfaceStyle = .dark
//        assertSnapshots(matching: vc, as: [
//            .wait(for: 0.5, on: .image(on: .iPhone8))
//        ])
//    }
}
