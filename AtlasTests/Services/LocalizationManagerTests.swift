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
        let result = sut.localize(key, tableName: "SignUp")
        XCTAssertEqual(result, "Testing")
    }
    
    func testDutch_myName() {
        let locale = Locale(identifier: "nl")
        sut = LocalizationManager(locale: locale)
        
        let key = "myName"
        let result = sut.localize(key, tableName: "SignUp")
        XCTAssertEqual(result, "Mijn naam")
    }
    
    func testEnglishDefault_myName() {
        sut = LocalizationManager()
        
        let key = "myName"
        let result = sut.localize(key, tableName: "SignUp")
        XCTAssertEqual(result, "My name")
    }
    
    func testFrench_myName_defaultToEnlish() {
        let locale = Locale(identifier: "fr")
        sut = LocalizationManager(locale: locale)
        
        let key = "myName"
        let result = sut.localize(key, tableName: "SignUp")
        XCTAssertEqual(result, "My name")
    }
}
