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
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_mobileClientInitialization_error() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(),
            awsMobileClient: StubAuthClient(error: AuthError.generic)
        )
        
        let status = sut.initialize(withUID: nil)
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.error, AuthError.generic)
    }
    
    func test_mobileClientObservation_unknown() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(),
            awsMobileClient: StubAuthClient(value: .unknown, observedValues: [.unknown])
        )
        
        let status = sut.initialize(withUID: nil)
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_mobileClientObservation_signIn() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(),
            awsMobileClient: StubAuthClient(value: .unknown, observedValues: [.confirmed, .signedIn])
        )
        
        let status = sut.observe()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut, .confirmed, .signedIn])
    }
    
    func test_appleAuthInitialization_invalidUID() {
        let validUID = "abcxyz"
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown)
        )
        
        let status = sut.getAppleCredentialState(forUID: "")
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.notFound])
    }
    
    func test_appleAuthInitialization_validUID() {
        let validUID = "abcxyz"
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown)
        )
        
        let status = sut.getAppleCredentialState(forUID: validUID)
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.authorized])
    }
    
    func test_appleAuthInitialized_mobileClientInitialized_valid() {
        let validUID = "abcxyz"
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .signedIn)
        )
        
        let status = sut.initialize(withUID: validUID)
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func test_appleAuthInitialized_invalid_mobileClient_initialized() {
        let validUID = "abcxyz"
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown)
        )
        
        let status = sut.initialize(withUID: nil) //invalid uid
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuthInitialized_valid_mobileClient_initialized_signedOut() {
        let validUID = "abcxyz"
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .signedOut)
        )
        
        let status = sut.initialize(withUID: validUID)
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuth_valid_mobileClient_signedOut_observe_signIn() {
        let validUID = "abcxyz"
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .signedOut, observedValues: [.confirmed, .signedIn])
        )
        
        let status = sut.initialize(withUID: validUID)
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuth_invalid_mobileClient_signOut() {
        let validUID = "abcxyz"
        
        let awsMobileClient = StubAuthClient(value: .signedIn)
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: awsMobileClient
        )
        
        let status = sut.initialize(withUID: nil)
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.signedOut])
        XCTAssertTrue(awsMobileClient.signOutCalled)
    }
    
    func test_appleAuthRevoked_mobileClient_signOut() {
        let validUID = "abcxyz"
        
        let appleAuthService = StubAppleAuthService(validUID: validUID)
        let awsMobileClient = StubAuthClient(value: .signedIn)
        
        sut = SessionService(
            appleAuthService: appleAuthService,
            awsMobileClient: awsMobileClient
        )
        
        let status = sut.initialize(withUID: validUID)
        sut.observeRevocation()
        let spy = StateSpy(publisher: status)
        // make sure to observe future authstatus values
        _ = appleAuthService.observeAppleIDRevocation()
        
        XCTAssertTrue(awsMobileClient.signOutCalled)
        XCTAssertEqual(awsMobileClient.signOutCalledCount, 1)
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    // MARK: - Helpers
    final class StateSpy<T> {
        private (set) var values: [T] = []
        private (set) var error: AuthError?
        private var cancellables = Set<AnyCancellable>()
        
        init(publisher: AnyPublisher<T, AuthError>) {
            publisher
                .sink(
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error): self?.error = error
                        case .finished: break
                        }
                    },
                    receiveValue: { [weak self] value in
                        self?.values.append(value)
                    }
            ).store(in: &cancellables)
        }
    }
}
