//
//  APIClientTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 03/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
@testable import Atlas

class APIClientTests: XCTestCase {
    class MockAPIClient: APIClientProtocol {
        var initialized: Bool
        
        init() {
            initialized = true
        }
        
        func fetch() {
            
        }
    }

    var sut: APIClientProtocol!
    
    override func setUp() {
        super.setUp()
        sut = MockAPIClient()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testAPIClient_initialized() {
        let client = MockAPIClient()
        
        XCTAssertFalse(client.initialized)
    }
}
