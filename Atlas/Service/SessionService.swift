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
}

final class SessionService: SessionServiceProtocol {
    private let appleAuthService: AppleAuthServiceProtocol!
    private let awsMobileClient: AuthClientProtocol!
    private let keychainManager: KeychainManagerProtocol!
    
    private (set) var status = CurrentValueSubject<AWSAuthState, AuthError>(.unknown)
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
                    self.awsMobileClient.signOut()
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
            .append(awsMobileClient.observe())
            .merge(with: observeRevocation())
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func observeRevocation() -> AnyPublisher<AWSAuthState, AuthError> {
        appleAuthService.observeAppleIDRevocation()
            .map({ [unowned self] _ in
                self.awsMobileClient.signOut()
                return .signedOut
            })
            .setFailureType(to: AuthError.self)
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
        case .signedIn:
            return .signedIn
        default:
            return .signedOut
        }
    }
    
    func setupSUBObserver() {
//        status
//            .filter({ $0 == .signedIn })
//            .flatMap({ [weak self] _ in self!.fetchSub() })
//            .subscribe(cognitoSUB)
//            .store(in: &cancellables)
    }
    
    func fetchSub() -> AnyPublisher<String, AuthError> {
//        guard let sub = self.sub else {
//            return awsMobileClient.getCognitoSUB()
//                .eraseToAnyPublisher()
//        }
//
        return Just<String>("sub")
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
}
