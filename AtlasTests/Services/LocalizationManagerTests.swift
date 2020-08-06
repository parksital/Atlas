//
//  LocalizationManagerTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class LocalizationManagerTests: XCTestCase {
    private let tableName = "LocalizedTest"
    private var sut: LocalizationManager!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultEnglish() {
        sut = LocalizationManager()
        let key = "thisIsATest"
        let result = sut.localize(key, tableName: tableName)
        XCTAssertEqual(result, "This is a test")
    }
    
    func testLocaleSetTo_dutch() {
        let locale = Locale(identifier: "nl")
        sut = LocalizationManager(locale: locale)
        let key = "thisIsATest"
        let result = sut.localize(key, tableName: tableName)
        XCTAssertEqual(result, "Dit is een test")
    }
    
    func testDutch_myName() {
        let locale = Locale(identifier: "nl")
        sut = LocalizationManager(locale: locale)
        
        let key = "myName"
        let result = sut.localize(key, tableName: tableName)
        XCTAssertEqual(result, "Mijn naam")
    }
    
    func testEnglishDefault_myName() {
        sut = LocalizationManager()
        
        let key = "myName"
        let result = sut.localize(key, tableName: tableName)
        XCTAssertEqual(result, "My name")
    }
    
    func testFrench_myName_defaultToEnlish() {
        let locale = Locale(identifier: "fr")
        sut = LocalizationManager(locale: locale)
        
        let key = "myName"
        let result = sut.localize(key, tableName: tableName)
        XCTAssertEqual(result, "My name")
    }
}
