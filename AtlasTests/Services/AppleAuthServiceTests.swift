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

class AppleAuthServiceTests: XCTestCase {
    private let validUID = "david.appleid.uid"
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

extension XCTestCase {
    // MARK: - Helpers
    final class StateSpy<T, E: Error> {
        private (set) var values: [T] = []
        private (set) var error: E?
        private var cancellables = Set<AnyCancellable>()
        
        init(publisher: AnyPublisher<T, E>) {
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
