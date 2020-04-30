//
//  EventDetailSnapshotTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 29/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import SnapshotTesting


// MARK: - Note:
/*
 for some reason the snapshot for the  first device
 does not show async loaded data.
 
 we have to use: sut.view.setNeedsDisplay()
 source: https://github.com/pointfreeco/swift-snapshot-testing/issues/297
*/
class EventDetailSnapshotTests: XCTestCase {
    private var sut: EventDetailViewController!
    
    override func setUp() {
        super.setUp()
        sut = SceneContainer.shared.container
            .resolve(EventDetailViewController.self)!
        
        sut.interactor?.eventTitle = "SPICE"
        sut.interactor?.eventID = "a313dd4e-a68c-4240-957a-c9b9dba85ca0"
        
//        record = true
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchEventDetailSuccess() {
        let vc = UINavigationController(rootViewController: sut)
        sut.view.setNeedsDisplay() // see note above
        assertSnapshots(matching: vc, as: [
            .wait(for: 0.5, on: .image(on: .iPhoneX))
        ])
    }

    func testFetchEventDetailSuccessDark() {
        let vc = UINavigationController(rootViewController: sut)
        vc.overrideUserInterfaceStyle = .dark
        sut.view.setNeedsDisplay()
        assertSnapshots(matching: vc, as: [
            .wait(for: 0.5, on: .image(on: .iPhoneX))
        ])
    }
}
