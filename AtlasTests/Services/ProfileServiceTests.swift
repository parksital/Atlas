//
//  ProfileServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class ProfileServiceTests: XCTestCase {
    private var sut: ProfileServiceProtocol!
    
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
    
    func testDeinit() {
        sut = makeSUT()
        let p = sut.getUserByID(id: "")
        let spy = StateSpy(publisher: p)
        sut = nil
        
        XCTAssertNil(sut)
    }
    
    func testGetUser() {
        sut = makeSUT()
        let p = sut.getUserByID(id: "")
        let spy = StateSpy(publisher: p)
        
        XCTAssertNil(spy.error)
    }
}

extension ProfileServiceTests {
    func makeSUT() -> ProfileService {
        ProfileService.fixture()
    }
}
