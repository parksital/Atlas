//
//  AuthClientProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 28/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSMobileClient
import AuthenticationServices
import Combine

protocol AuthClientProtocol {
    var status: CurrentValueSubject<AuthStatus, Never> { get }
    
    func initialize()
    func signUp(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError>
    func signIn(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError>
    func logOut()
}

private extension AuthClientProtocol {
    func mapAWSMobileClientError(_ error: Error) -> AuthError {
        guard let awsError = error as? AWSMobileClientError else { return .generic}
        switch awsError {
            // implement the rest
        default:
            assertionFailure(awsError.localizedDescription)
            return AuthError.generic
        }
    }
}

private extension AWSMobileClient {
    func checkAppleIDCredentials() {
        guard let uid = KeychainWrapper.standard.string(forKey: "uid") else {
            logOut()
            return
        }
        
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: uid) { [weak self]  credentialState, error in
            guard let self = self else { return }
            switch credentialState {
            case .authorized:
                self.intializeAWSMobileClient()
            case .notFound, .transferred, .revoked:
                self.logOut()
                self.intializeAWSMobileClient()
            @unknown default:
                break
            }
        }
    }
    
    func intializeAWSMobileClient() {
        initialize { [weak self] userState, error in
            guard let self = self else { return }
            
            if let error = error {
                assertionFailure(error.localizedDescription)
            } else if let state = userState {
                switch state {
                case .signedIn: break
                case .signedOut: break // show sign in view
                case .signedOutFederatedTokensInvalid: break
                case .signedOutUserPoolsTokenInvalid: break
                case .guest, .unknown: self.logOut()
                }
            }
        }
    }
}

extension AWSMobileClient: AuthClientProtocol {
    var status: CurrentValueSubject<AuthStatus, Never> {
        return .init(.unknown)
    }
    
    func initialize() {
        checkAppleIDCredentials()
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError> {
        return Future<AuthStatus, Error> { [weak self] promise in
            guard let self = self else {
                assertionFailure("AuthClient not injected")
                return
            }
            
            self.signUp(username: email, password: password) { authResult, authError in
                guard authError == nil else {
                    let error = self.mapAWSMobileClientError(authError!)
                    promise(.failure(error))
                    return
                }
                
                if let result = authResult {
                    switch result.signUpConfirmationState {
                    case .confirmed:
                        promise(.success(.confirmed))
                    case .unconfirmed:
                        promise(.success(.unauthenticated))
                    case .unknown:
                        promise(.success(.unknown))
                    }
                }
            }
        }
        .mapError(mapAWSMobileClientError(_:))
        .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError> {
        return Future<AuthStatus, Error> { [weak self] promise in
            guard let self = self else {
                assertionFailure("AuthClient not injected")
                return
            }
            
            self.signIn(username: email, password: password) { authResult, authError in
                guard authError == nil else {
                    let error = self.mapAWSMobileClientError(authError!)
                    promise(.failure(error))
                    return
                }
                
                if let result = authResult {
                    switch result.signInState {
                    case .signedIn:
                        promise(.success(.signedIn))
                    default:
                        promise(.success(.unknown))
                    }
                }
            }
        }
        .mapError(mapAWSMobileClientError(_:))
        .eraseToAnyPublisher()
    }
    
    func logOut() {
        _ = KeychainWrapper.standard.removeAllKeys()
        self.signOut()
    }
}
