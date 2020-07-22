//
//  AppleAuthServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import AuthenticationServices
import Combine

protocol AppleIDProviderProtocol {
    func getCredentialState(
        forUserID: String,
        completion: (AppleIDCredentialState, Error?) -> Void
    )
}

struct MockAppleIDProvider: AppleIDProviderProtocol {
    private let validUID = "apple.auth.uid"
    func getCredentialState(forUserID: String, completion: (AppleIDCredentialState, Error?) -> Void) {
        guard forUserID == validUID else {
            completion(.notFound, nil)
            return
        }
        
        completion(.authorized, nil)
    }
}


protocol AppleAuthServiceProtocol {
    func checkAppleIDCredentials(forUID uid: String?) -> Future<AppleIDCredentialState, Error>
    func observeAppleIDRevocation() -> AnyPublisher<Notification, Never>
}

typealias AppleIDCredentialState = ASAuthorizationAppleIDProvider.CredentialState
final class AppleAuthService: AppleAuthServiceProtocol {
    private let appleIDProvider: AppleIDProviderProtocol!
    
    init(appleIDProvider: AppleIDProviderProtocol) {
        self.appleIDProvider = appleIDProvider
    }
    
    func checkAppleIDCredentials(forUID uid: String?) -> Future<AppleIDCredentialState, Error> {
        Future<AppleIDCredentialState, Error> { [appleIDProvider] promise in
            guard let id = uid else {
                promise(.success(.notFound))
                return
            }
            
            appleIDProvider?.getCredentialState(forUserID: id) { (state, error) in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                promise(.success(state))
            }
        }
    }
    
    func observeAppleIDRevocation() -> AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)
            .eraseToAnyPublisher()
    }
}

class AppleAuthServiceTests: XCTestCase {
    private let validUID = "apple.auth.uid"
    private var sut: AppleAuthServiceProtocol!
    
    override func setUp() {
        sut = AppleAuthService(appleIDProvider: MockAppleIDProvider())
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
    }
    
    func testAppleIDCredentials_forNilUID_notFound() {
        let f = sut.checkAppleIDCredentials(forUID: nil)
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.notFound])
    }
    
    func testAppleIDCredentials_validUID_authorized() {
        let f = sut.checkAppleIDCredentials(forUID: validUID)
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.authorized])
    }
    
    func testAppleIDCredentials_invalidUID_notFound() {
        let f = sut.checkAppleIDCredentials(forUID: "apple.invalid.uid")
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.notFound])
    }
}

private extension AppleAuthServiceTests {
    // MARK: - Helpers
    final class StateSpy<T> {
        private (set) var values: [T] = []
        private (set) var error: Error?
        private var cancellables = Set<AnyCancellable>()
        
        init(publisher: AnyPublisher<T, Error>) {
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
