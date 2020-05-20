//
//  AccountSnapshotTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 20/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import SnapshotTesting

class AccountSnapshotTests: XCTestCase {
    private var sut: AccountViewController!
    override func setUp() {
        super.setUp()
        sut = SceneContainer.shared.container
            .resolve(AccountViewController.self)!
        
//        record = true
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testEmptyAccount() {
        let vc = UINavigationController(rootViewController: sut)
        assertSnapshots(matching: vc, as: [
            .wait(for: 0.5, on: .image(on: .iPhone8))
        ])
    }
}
