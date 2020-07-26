//
//  SessionService.swift
//  Atlas
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol SessionServiceProtocol {
    var status: CurrentValueSubject<AuthStatus, AuthError> { get }
    
    func setup()
    func initialize() -> AnyPublisher<AuthStatus, AuthError>
    func observe() -> AnyPublisher<AuthStatus, AuthError>
    func initializeAuthClient() -> Future<AuthStatus, AuthError>
    func getAppleAuthStatus(forUID uid: String?) -> AnyPublisher<AppleIDCredentialState, AuthError>
    func fetchSUB() -> AnyPublisher<String, AuthError>
}

class SessionService: SessionServiceProtocol {
    private let appleAuthService: AppleAuthServiceProtocol!
    private let authClient: AuthClientProtocol!
    private let keychain: KeychainManagerProtocol!
    private (set) var status =  CurrentValueSubject<AuthStatus, AuthError>(.unknown)
    private var cancellables = Set<AnyCancellable>()
    
    init(
        appleAuthService: AppleAuthServiceProtocol,
        authClient: AuthClientProtocol,
        keychain: KeychainManagerProtocol
    ) {
        self.appleAuthService = appleAuthService
        self.authClient = authClient
        self.keychain = keychain
    }
    
    func setup() {
        initialize()
            .merge(with: observe())
            .removeDuplicates()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] value in
                    if value == .signedOut {
                        self?.authClient.signOut()
                    }
                    self?.status.send(value)
            })
            .store(in: &cancellables)
        
        observeRevocation()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [authClient] _ in
                    authClient?.signOut()
            })
            .store(in: &cancellables)
    }
    
    func initialize() -> AnyPublisher<AuthStatus, AuthError> {
        let uid = keychain.getValue(forKey: "uid")
        
        return getAppleAuthStatus(forUID: uid)
            .map({ $0 == .authorized})
            .zip(initializeAuthClient())
            .map({ (authorized, authStatus) in
                print("appleAuth: \(authorized), cognito: \(authStatus)")
                if authorized {
                    return self.handleAuthStatus(authStatus)
                } else {
                    return .signedOut
                }
            })
            .eraseToAnyPublisher()
    }
    
    func handleAuthStatus(_ authStatus: AuthStatus) -> AuthStatus {
        switch authStatus {
        case .signedOut: // + .expiredToken:
            // sign in first
            return .signedIn
        default:
            return authStatus
        }
    }
    
    func initializeAuthClient() -> Future<AuthStatus, AuthError> {
        authClient.initialize()
    }
    
    func getAppleAuthStatus(forUID uid: String?) -> AnyPublisher<AppleIDCredentialState, AuthError> {
        appleAuthService
            .checkAppleIDCredentials(forUID: uid)
            .mapError({ AuthError.appleIDError($0) })
            .eraseToAnyPublisher()
    }
    
    func observe() -> AnyPublisher<AuthStatus, AuthError> {
        authClient.observe()
    }
    
    func observeRevocation() -> AnyPublisher<AuthStatus, AuthError> {
        appleAuthService.observeAppleIDRevocation()
            .setFailureType(to: AuthError.self)
            .map({ _ in .signedOut })
            .eraseToAnyPublisher()
    }
    
    func fetchSUB() -> AnyPublisher<String, AuthError> {
        guard let sub = keychain.getValue(forKey: "sub") else {
            return authClient.getCognitoSUB()
                .eraseToAnyPublisher()
        }
        
        return Just<String>(sub)
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
}

extension SessionService {
    static func fixture(signedIn: Bool = false) -> SessionService {
        if signedIn {
            let authData = AppleAuthData.fixture()
            
            let keychain = MockKeychain()
            keychain.setValue(authData.uid, forKey: "uid")
            
            let authClient = MockAuthClient(existingUsers: [authData.email])
            
            return SessionService(
                appleAuthService: AppleAuthService.fixture(),
                authClient: authClient,
                keychain: keychain
            )
        } else {
            return SessionService(
                appleAuthService: AppleAuthService.fixture(),
                authClient: MockAuthClient(),
                keychain: MockKeychain()
            )
        }
    }
}
