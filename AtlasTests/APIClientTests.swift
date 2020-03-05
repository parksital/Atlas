//
//  APIClientTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 03/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
class APIClientTests: XCTestCase {
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
        XCTAssertNotNil(sut)
    }
    
    func testAPIClient_request_allEvents() {
        let promise = expectation(description: "fetching events success")
        
        sut.request(data: [EventSummary].self) { result in
            switch result {
            case .success(let events):
                XCTAssertFalse(events.isEmpty)
                promise.fulfill()
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [promise], timeout: 0.5)
    }
    
    func testAPIClientRequest_modelMismatch() {
        let promise = expectation(description: "JSONDecoder error")
        
        sut.request(data: String.self) { result in
            switch result {
            case .success:
                XCTFail("expecting JSONDecoder error")
            case .failure:
                promise.fulfill()
            }
        }
        
        wait(for: [promise], timeout: 0.5)
    }
}
