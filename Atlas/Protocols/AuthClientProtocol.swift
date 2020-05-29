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
    func initialize() -> Future<AWSAuthState, AuthError>
    func observe() -> Future<AWSAuthState, AuthError>
    func getCognitoSUB() -> Future<String?, Never>
    func signUp(email: String, password: String, attributes: [String: String]) -> AnyPublisher<AWSAuthState, AuthError>
    func signIn(email: String, password: String) -> AnyPublisher<AWSAuthState, AuthError>
    func signOut()
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

extension AWSMobileClient: AuthClientProtocol {
    func initialize() -> Future<AWSAuthState, AuthError> {
        return Future<AWSAuthState, AuthError> { [weak self] promise in
            guard let self = self else { return }
            self.initialize { userState, error in
                if let error = error {
                    let authErrror = self.mapAWSMobileClientError(error)
                    promise(.failure(authErrror))
                } else if let state = userState {
                    switch state {
                    case .signedIn: promise(.success(.signedIn))
                    case .signedOut: promise(.success(.signedOut))
                    case .signedOutUserPoolsTokenInvalid: promise(.success(.expiredToken))
                    default: break
                    }
                }
            }
        }
    }
    
    func observe() -> Future<AWSAuthState, AuthError> {
        return Future<AWSAuthState, AuthError> { [weak self] promise in
            guard let self = self else { return }
            self.addUserStateListener(self) { userState, userInfo in
                switch userState {
                case .signedIn: promise(.success(.signedIn))
                case .signedOut: promise(.success(.signedOut))
                case .signedOutUserPoolsTokenInvalid: promise(.success(.expiredToken))
                default: break
                }
            }
        }
    }
    
    func getCognitoSUB() -> Future<String?, Never> {
        return Future<String?, Never> { [weak self] promise in
            self?.getUserAttributes(completionHandler: { attributes, error in
                guard error == nil else {
                    print("Attibutes Error: ", error!.localizedDescription)
                    promise(.success(nil))
                    return
                }
                
                guard let dict = attributes, let value = dict["sub"] else {
                    promise(.success(nil))
                    return
                }
                
                promise(.success(value))
            })
        }
    }
    
    func signUp(email: String, password: String, attributes: [String: String]) -> AnyPublisher<AWSAuthState, AuthError> {
        return Future<AWSAuthState, Error> { [weak self] promise in
            guard let self = self else {
                assertionFailure("AuthClient not injected")
                return
            }
            
            self.signUp(
                username: email,
                password: password,
                userAttributes: attributes
            ) { authResult, authError in
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
                            promise(.success(.signedOut))
                        case .unknown:
                            promise(.success(.unknown))
                        }
                    }
            }
        }
        .mapError(mapAWSMobileClientError(_:))
        .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<AWSAuthState, AuthError> {
        return Future<AWSAuthState, Error> { [weak self] promise in
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
}
