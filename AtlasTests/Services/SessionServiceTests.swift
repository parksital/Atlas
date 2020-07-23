//
//  SessionServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import Combine

class SessionServiceTests: XCTestCase {
    private var sut: SessionServiceProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.forEach({ $0.cancel() })
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialization() {
        sut = makeSUT()
        XCTAssertNotNil(sut)
    }
    
    func testDeinit() {
        sut = makeSUT()
        sut = nil
        XCTAssertNil(sut)
    }
    
    func testInitialize_appleAuth_notFound() {
        sut = makeSUT()
        let p = sut.getAppleAuthStatus(forUID: "")
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.notFound])
    }
    
    func testInitialize_appleAuth_authorized() {
        sut = makeSUT()
        let p = sut.getAppleAuthStatus(forUID: "david.appleid.uid")
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.authorized])
    }
    
    func testInitialize_authClient_unknown() {
        sut = makeSUT()
        let p = sut.initializeAuthClient()
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.unknown])
    }
    
    func testInitialize_authClient_signedIn() {
        // doesn't matter which e-mail you enter, for now
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        
        let p = sut.initializeAuthClient()
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func testStatus_initial_unknown() {
        sut = makeSUT()
        let s = sut.status
        let spy = StateSpy(publisher: s.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.unknown])
    }
    
    func testInit_appleAuthNotFound_clientUnknown() {
        sut = makeSUT()
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "")
        
        XCTAssertEqual(sut.status.value, .signedOut)
        XCTAssertEqual(spy.values, [.unknown, .signedOut])
    }
    
    func testInit_afterAppleAuth_clientSignedIn() {
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "david.appleid.uid")
        XCTAssertEqual(spy.values, [.unknown, .signedIn])
        XCTAssertEqual(sut.status.value, .signedIn)
    }
    
    func testInit_afterAppleAuth_notFound() {
        sut = makeSUT()
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "")
        
        XCTAssertEqual(spy.values, [.unknown, .signedOut])
        XCTAssertEqual(sut.status.value, .signedOut)
    }
    
    func testInit_appleAuth_revoked_clientSignedIn() {
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "")
        
        XCTAssertEqual(authClient.signOutCalledCount, 1)
        XCTAssertEqual(spy.values, [.unknown, .signedOut])
    }
    
    func testObservation_signIn() {
        let authClient = MockAuthClient(
            observedValues: [.unknown, .confirmed, .signedUp, .signedIn]
        )
        
        sut = makeSUT(authClient: authClient)
        let promise = expectation(description: "received all observed values")
        var result: [AuthStatus] = []
        
        sut.observe()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertEqual(result.count, 4)
                    promise.fulfill()
                default:
                    XCTFail()
                }
            }, receiveValue: { value in
                result.append(value)
            })
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1.5)
    }
    
    func testStatusObservation_signIn() {
        let authClient = MockAuthClient(
            observedValues: [.unknown, .confirmed, .signedUp, .signedIn]
        )
        
        sut = makeSUT(authClient: authClient)
        let promise = expectation(description: "received all observed values")
        var result: [AuthStatus] = []
        
        sut.observe()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertEqual(result.count, 4)
                    promise.fulfill()
                default:
                    XCTFail()
                }
            }, receiveValue: { value in
                result.append(value)
            })
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1.5)
    }
    
}

private extension SessionServiceTests {
    func makeSUT(
        authClient: AuthClientProtocol = MockAuthClient()
    ) -> SessionService {
        let appleAuthService = AppleAuthService(appleIDProvider: MockAppleIDProvider())
        
        return SessionService(
            appleAuthService: appleAuthService,
            authClient: authClient
        )
    }
}
