//
//  AuthClientProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSMobileClient
import Combine

protocol AuthClientProtocol {
    func initialize() -> Future<AuthStatus, AuthError>
    
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, AuthError>
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, AuthError>
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
    func initialize() -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { promise in
            promise(.success(.unknown))
        }
    }
    
    func signUp(email: String, password: String, attributes: [String : String]) -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { [weak self] promise in
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
                    default: break
                    }
                }
            }
        }
        //        .mapError(mapAWSMobileClientError(_:))
    }
    
    func signIn(email: String, password: String) -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { [weak self] promise in
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
                    default: break
                    }
                }
            }
        }
        //        .mapError(mapAWSMobileClientError(_:))
    }
}

