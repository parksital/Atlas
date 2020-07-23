//
//  SessionService.swift
//  Atlas
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

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
    
    func initialize() {
        let uid = keychain.getValue(forKey: "uid")
        
        getAppleAuthStatus(forUID: uid)
            .map({ $0 == .authorized})
            .zip(initializeAuthClient())
            .sink(receiveCompletion: { _ in},
                  receiveValue: { [unowned self] (authorized, authStatus) in
                    if authorized {
                        if authStatus == .signedIn {
                            self.status.send(.signedIn)
                        }
                    } else {
                        self.status.send(.signedOut)
                        self.authClient.signOut()
                    }
            })
            .store(in: &cancellables)
    }
    
    func initializeAuthClient() -> Future<AuthStatus, AuthError> {
        authClient.initialize()
    }
    
    func getAppleAuthStatus(forUID uid: String?) -> AnyPublisher<AppleIDCredentialState, AuthError> {
        appleAuthService
            .checkAppleIDCredentials(forUID: uid)
            .mapError({
                AuthError.appleIDError(underlyingError: $0)
            })
            .eraseToAnyPublisher()
    }
    
    func observe() -> AnyPublisher<AuthStatus, AuthError> {
        authClient.observe()
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
