//
//  SessionServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

protocol SessionServiceProtocol {
    
}

struct SessionService: SessionServiceProtocol {
    
}

class SessionServiceTests: XCTestCase {
    private var sut: SessionServiceProtocol!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        sut = makeSUT()
        XCTAssertNotNil(sut)
    }
}

private extension SessionServiceTests {
    func makeSUT() -> SessionService {
        return SessionService()
    }
}
