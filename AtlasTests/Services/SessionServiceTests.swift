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
        
        let p = sut.initialize()
        let spy = StateSpy(publisher: p)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func testInit_appleAuth_revoked_clientSignedIn() {
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        sut.setup()
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        XCTAssertEqual(authClient.signOutCalledCount, 1)
        XCTAssertEqual(spy.values, [.signedOut])
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
    
//    func testStatusObservation_signIn() {
//        let authClient = MockAuthClient(
//            observedValues: [.unknown, .confirmed, .signedUp, .signedIn]
//        )
//
//        sut = makeSUT(authClient: authClient)
//        let promise = expectation(description: "received all observed values")
//        var result: [AuthStatus] = []
//
//        sut.observe()
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    XCTAssertEqual(result.count, 4)
//                    promise.fulfill()
//                default:
//                    XCTFail()
//                }
//            }, receiveValue: { value in
//                result.append(value)
//            })
//            .store(in: &cancellables)
//
//        wait(for: [promise], timeout: 1.5)
//    }
    
    func testInit_withUIDfromKeychain() {
        let authData = AppleAuthData.fixture()
        let keychain = MockKeychain()
        // signed in before -> uid saved
        keychain.setValue(authData.uid, forKey: "uid")
        
        // signed in before -> email saved
        let authClient = MockAuthClient(
            existingUsers: [authData.email]
        )
        
        sut = makeSUT(authClient: authClient, keychain: keychain)
        
        let p = sut.initialize()
        let spy = StateSpy(publisher: p)
        
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func testFetchingSUB() {
        sut = makeSUT()
        let p = sut.fetchSUB().eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        XCTAssertEqual(spy.values, ["aws.cognito.sub"])
    }
    
    func testGetSUBfromKeychain() {
        let keychain = MockKeychain()
        keychain.setValue("aws.cognito.sub.david", forKey: "sub")
        sut = makeSUT(keychain: keychain)
        
        let p = sut.fetchSUB().eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        XCTAssertEqual(spy.values, ["aws.cognito.sub.david"])
    }
}

private extension SessionServiceTests {
    func makeSUT(
        authClient: AuthClientProtocol = MockAuthClient(),
        keychain: KeychainManagerProtocol = MockKeychain()
    ) -> SessionService {
        let appleAuthService = AppleAuthService(appleIDProvider: MockAppleIDProvider())
        
        return SessionService(
            appleAuthService: appleAuthService,
            authClient: authClient,
            keychain: keychain
        )
    }
}
