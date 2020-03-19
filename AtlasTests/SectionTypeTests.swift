//
//  SectionTypeTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 19/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class SectionTypeTests: XCTestCase {
    
    func testInteration() {
        var result: Int = 0
        SectionType.allCases.forEach { _ in result += 1 }
        
        let expectation = SectionType.allCases.count
        XCTAssertEqual(expectation, result)
    }
    
    func testInitializationWithValidInt() {
        let result = SectionType(rawValue: 1)
        let expectation = SectionType.tomorrow
        
        XCTAssertEqual(expectation, result)
    }
    
    func testInitializationWithInvalidInt() {
        let result = SectionType(rawValue: -1)
        
        XCTAssertEqual(nil, result)
    }
    
    func testInitializedWithCustomStringNoValue() {
        let sectionType = SectionType.date(nil)
        let result = sectionType.header
        
        XCTAssertNil(result)
    }
    
    func testInitializedWithCustomStringEmpty() {
        let string = ""
        let sectionType = SectionType.date(string)
        let result = sectionType.header
        
        XCTAssertNil(result)
    }
    
    func testInitializedWithCustomStringValue() {
        let string = "Date"
        let sectionType = SectionType.date(string)
        let result = sectionType.header
        
        XCTAssertEqual(result, string)
    }
}
