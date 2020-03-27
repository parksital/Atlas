//
//  EventListSnapshotTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 25/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import FBSnapshotTestCase

class EventListSnapshotTests: FBSnapshotTestCase {
    var sut: UIViewController!
    override func setUp() {
        super.setUp()
        sut = EventListViewController()
        self.recordMode = false
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testViewController() {
        _ = sut.view
        FBSnapshotVerifyViewController(sut)
    }
}
