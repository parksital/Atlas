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
    func initialize() -> Future<AWSAuthState, Error>
    func signUp(email: String, password: String) -> AnyPublisher<AWSAuthState, AuthError>
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
    func initialize() -> Future<AWSAuthState, Error> {
        return Future<AWSAuthState, Error> { [weak self] promise in
            guard let self = self else { return }
            self.initialize { userState, error in
                if let error = error {
                    promise(.failure(error))
                } else if let state = userState {
                    print("awsmobileclient init- status: ",state.rawValue)
                    switch state {
                    case .signedIn:
                        // we initialised with a user signed in, carry on
                        break
                    case .signedOut:
                        // we initialised with a user signed out
                        break
                    case .signedOutUserPoolsTokenInvalid:
                        // sign in again with appleID credentials, handle in sessionservice
                        break
                    case .signedOutFederatedTokensInvalid:
                        // were not using this
                        break
                    case .guest:
                        // were not using this
                        break
                    case .unknown:
                        // initial user state before awsmobileclient is initialized
                        break
                    }
                }
            }
        }
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<AWSAuthState, AuthError> {
        return Future<AWSAuthState, Error> { [weak self] promise in
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
