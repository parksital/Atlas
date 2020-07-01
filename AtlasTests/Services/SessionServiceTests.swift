//
//  SessionServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 01/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import Combine

class SessionServiceTests: XCTestCase {
    var sut: SessionServiceProtocol!
    
    override func setUp() {
        super.setUp()
        sut = SessionService(
            appleAuthService: MockAppleAuthService(),
            awsMobileClient: MockAuthClient()
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_intialStatus_unknown() {
        let status = sut.status.eraseToAnyPublisher()
        let spy =  StatusSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.unknown])
    }
    
    func test_statusInitialized() {
        let status = sut.status.eraseToAnyPublisher()
        let spy =  StatusSpy(publisher: status)
        
        sut.setupInitialization()
        
        XCTAssertEqual(spy.values, [.unknown])
    }
    
    class StatusSpy {
        private (set) var values: [AWSAuthState] = []
        private var cancellabes = Set<AnyCancellable>()
        
        init(publisher: AnyPublisher<AWSAuthState, AuthError>) {
            publisher
                .sink(receiveCompletion: { _ in },
                      receiveValue: { [weak self] value in
                        self?.values.append(value)
                }).store(in: &cancellabes)
        }
    }
}
