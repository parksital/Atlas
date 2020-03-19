//
//  SectionTypeTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 19/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class SectionTypeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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
}
