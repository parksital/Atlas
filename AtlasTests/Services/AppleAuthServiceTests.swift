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
    func checkAppleIDCredentials(
        forUID uid: String?,
        completion: @escaping (AppleIDCredentialState, Error?) -> Void
    )
    
//    func checkAppleIDCredentials(forUID uid: String?) -> Future<AppleIDCredentialState, Error>
}

typealias AppleIDCredentialState = ASAuthorizationAppleIDProvider.CredentialState
final class AppleAuthService: AppleAuthServiceProtocol {
    private let appleIDProvider: AppleIDProviderProtocol!
    
    init(appleIDProvider: AppleIDProviderProtocol) {
        self.appleIDProvider = appleIDProvider
    }
    
    func checkAppleIDCredentials(forUID uid: String?, completion: @escaping (AppleIDCredentialState, Error?) -> Void) {
        
        guard let id = uid else {
            completion(.notFound, nil)
            return
        }
        
        appleIDProvider
            .getCredentialState(forUserID: id) { (state, error) in
                guard error == nil else { return }
                completion(state, nil)
        }
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
        sut.checkAppleIDCredentials(forUID: nil) { state, error in
                let result = state
                XCTAssertEqual(result, .notFound)
        }
    }
    
    func testAppleIDCredentials_validUID_authorized() {
        sut.checkAppleIDCredentials(forUID: validUID) { state, error in
            let result = state
            XCTAssertEqual(result, .authorized)
        }
    }
    
    func testAppleIDCredentials_invalidUID_notFound() {
        sut.checkAppleIDCredentials(forUID: "apple.invalid.uid") { state, error in
            let result = state
            XCTAssertEqual(result, .notFound)
        }
    }
}
