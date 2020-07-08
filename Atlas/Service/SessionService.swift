//
//  SessionService.swift
//  Atlas
//
//  Created by Parvin Sital on 11/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

protocol SessionServiceProtocol: class {
    var cognitoSUB: CurrentValueSubject<String, AuthError> { get }
    
    func initialize() -> AnyPublisher<AWSAuthState, AuthError>
    func getAppleCredentialState(forUID uid: String?) -> AnyPublisher<AppleIDCredentialState, AuthError>
    func observe() -> AnyPublisher<AWSAuthState, AuthError>
    func fetchSub() -> AnyPublisher<String, AuthError>
}

final class SessionService: SessionServiceProtocol {
    private let appleAuthService: AppleAuthServiceProtocol!
    private let awsMobileClient: AuthClientProtocol!
    private let keychainManager: KeychainManagerProtocol!
    
    private (set) var cognitoSUB = CurrentValueSubject<String, AuthError>("")

    private var cancellables = Set<AnyCancellable>()
    
    init(
        appleAuthService: AppleAuthServiceProtocol,
        awsMobileClient: AuthClientProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.appleAuthService = appleAuthService
        self.awsMobileClient = awsMobileClient
        self.keychainManager = keychainManager
    }
    
    deinit { cancellables.forEach { $0.cancel() } }
}

extension SessionService {
    func initialize() -> AnyPublisher<AWSAuthState, AuthError> {
        let userID = keychainManager.getValue(forKey: "uid")
        
        return getAppleCredentialState(forUID: userID)
            .allSatisfy({ $0 == .authorized })
            .zip(awsMobileClient.initialize())
            .map({ [unowned self] authorized, awsAuthState in
                if authorized {
                    return self.handleAuthState(awsAuthState)
                } else {
                    return .signedOut
                }
            }).eraseToAnyPublisher()
    }
    
    func getAppleCredentialState(forUID uid: String?) -> AnyPublisher<AppleIDCredentialState, AuthError> {
        appleAuthService.checkAppleIDAuthStatus(forUID: uid)
            .eraseToAnyPublisher()
    }
    
    func observe() -> AnyPublisher<AWSAuthState, AuthError> {
        initialize()
            .merge(with: observeRevocation())
            .append(awsMobileClient.observe())
            .removeDuplicates()
            .map({ [unowned self] value in
                if value == .signedOut {
                    print("appleID revoked")
                    self.awsMobileClient.signOut()
                    return .signedOut
                } else {
                    return value
                }
            })
            .eraseToAnyPublisher()
    }
    
    func observeRevocation() -> AnyPublisher<AWSAuthState, AuthError> {
        appleAuthService.observeAppleIDRevocation()
            .setFailureType(to: AuthError.self)
            .map({ _ in .signedOut })
            .eraseToAnyPublisher()
    }
    
    /// Handles the AWSAuthState after a successful AppleID authorization.
    /// - Parameter authState: the incoming AWSAuthState
    /// - Returns: new AWSAuthState after performing some actions
    func handleAuthState(_ authState: AWSAuthState) -> AWSAuthState {
        switch authState {
        case .signedOut, .expiredToken:
            // sign in first
            return .signedIn
        default:
            return authState
        }
    }
    
    func fetchSub() -> AnyPublisher<String, AuthError> {
        guard let sub = keychainManager.getValue(forKey: "sub") else {
            return awsMobileClient.getCognitoSUB()
                .eraseToAnyPublisher()
        }
        
        return Just<String>(sub)
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
}
