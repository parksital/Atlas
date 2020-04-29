//
//  AuthClientProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 28/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSMobileClient
import Combine

enum AuthStatus: String {
    case unknown
    case unauthenticated
    case confirmed
    case signedIn
    case signedOut
}

protocol AuthClientProtocol {
    var status: CurrentValueSubject<AuthStatus, Error> { get }
    
    func listen()
    func signUp(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError>
    func signIn(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError>
}

extension AuthClientProtocol {
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
    var status: CurrentValueSubject<AuthStatus, Error> {
        return .init(.unknown)
    }
    
    func listen() {
        addUserStateListener(self) { [status] userState, authInfo in
            switch userState {
            case .signedIn:
                status.send(.signedIn)
            case .signedOut:
                status.send(.signedOut)
            case .signedOutUserPoolsTokenInvalid:
                status.send(.signedOut)
            case .guest:
                status.send(.unauthenticated)
            default:
                status.send(.unknown)
            }
        }
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
}
