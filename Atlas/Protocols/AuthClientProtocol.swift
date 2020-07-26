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
    func observe() -> AnyPublisher<AuthStatus, AuthError>
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, AuthError>
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, AuthError>
    
    func getCognitoSUB() -> Future<String, AuthError>
    
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
    func initialize() -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { [weak self] promise in
            guard let self = self else { return }
            self.initialize { userState, error in
                print("awsMobileClient initialized with: ", userState)
                if let error = error {
                    let authErrror = self.mapAWSMobileClientError(error)
                    promise(.failure(authErrror))
                } else if let state = userState {
                    switch state {
                    case .signedIn: promise(.success(.signedIn))
                    case .signedOut: promise(.success(.signedOut))
                    default: promise(.success(.unknown))
                    }
                }
            }
        }
    }
    
    func observe() -> AnyPublisher<AuthStatus, AuthError> {
        let pts = PassthroughSubject<AuthStatus, AuthError>()
        
        self.addUserStateListener(self) { (userState, userInfo) in
            switch userState {
            case .signedIn: pts.send(.signedIn)
            case .signedOut: pts.send(.signedOut)
            default: break
            }
        }
        
        return pts.eraseToAnyPublisher()
    }
    
    func getCognitoSUB() -> Future<String, AuthError> {
        return Future<String, AuthError> { [weak self] promise in
            self?.getUserAttributes(completionHandler: { attributes, error in
                guard error == nil else {
                    print("Attibutes Error: ", error!.localizedDescription)
                    promise(.failure(.attributesError(error!)))
                    return
                }
                
                guard let dict = attributes, let sub = dict["sub"] else {
                    promise(.failure(.attributesError(error!)))
                    return
                }
                
                KeychainWrapper.standard.set(sub, forKey: "sub")
                promise(.success(sub))
            })
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
    }
}

