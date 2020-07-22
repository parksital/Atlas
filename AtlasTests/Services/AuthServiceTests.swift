//
//  AuthServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import AWSMobileClient

enum SignUpError: Error {
    case generic
    case existingEmail
}

extension SignUpError: Equatable { }

protocol AuthClientProtocol {
    func signUp(email: String, password: String, completion: @escaping (Result<String, SignUpError>) -> Void)
}

struct MockAuthClient: AuthClientProtocol {
    private let existingUsers = ["existing.user@domain.com"]
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, SignUpError>) -> Void) {
        guard !existingUsers.contains(email) else {
            completion(.failure(.existingEmail))
            return
        }
        
        completion(.success(email))
    }
}

protocol AuthServiceProtocol {
    func signUp(email: String, password: String, completion: @escaping (Result<String, SignUpError>) -> Void)
}

final class AuthService: AuthServiceProtocol {
    private let authClient: AuthClientProtocol!
    
    init(authClient: AuthClientProtocol) {
        self.authClient = authClient
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, SignUpError>) -> Void) {
        guard !email.isEmpty else {
            completion(.failure(SignUpError.generic))
            return
        }
        
        authClient.signUp(email: email, password: password, completion: completion)
    }
}

class AuthServiceTests: XCTestCase {
    private var sut: AuthServiceProtocol!
    
    override func setUp() {
        super.setUp()
        sut = AuthService(authClient: MockAuthClient())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSignUp_noData_failure() {
        let promise = expectation(description: "expecting failure")
        
        sut.signUp(email: "", password: "") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, SignUpError.generic)
                promise.fulfill()
            default:
                XCTFail("expecting failure")
            }
        }
        
        wait(for: [promise], timeout: 1.0)
    }
    
    func testSignUp_emailAlreadyExists_failure() {
        let promise = expectation(description: "expecting existing user failure")
        
        sut.signUp(email: "existing.user@domain.com", password: "password") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, SignUpError.existingEmail)
                promise.fulfill()
            default:
                XCTFail("expecting failure")
            }
        }
        
        wait(for: [promise], timeout: 1.0)
    }
    
    func testSignUp_success() {
        let promise = expectation(description: "successful sign up")
        
        sut.signUp(email: "new.user@domain.com", password: "password", completion: { result in
            switch result {
            case .failure(_):
                XCTFail()
            case .success(let value):
                XCTAssertEqual(value, "new.user@domain.com")
                promise.fulfill()
            }
        })
        
        wait(for: [promise], timeout: 1.0)
    }
}
