//
//  LocalizationManagerTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class LocalizationManagerTests: XCTestCase {
    private var sut: LocalizationManager!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLocalization() {
        sut = LocalizationManager()
        let key = "testing"
        let result = sut.localize(key, tableName: "SignUpStrings")
        XCTAssertEqual(result, "testen")
    }
}
