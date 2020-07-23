//
//  SessionServiceProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol SessionServiceProtocol {
    var status: CurrentValueSubject<AuthStatus, AuthError> { get }
    
    func initialize()
    func observe() -> AnyPublisher<AuthStatus, AuthError>
    func initializeAuthClient() -> Future<AuthStatus, AuthError>
    func getAppleAuthStatus(forUID uid: String?) -> AnyPublisher<AppleIDCredentialState, AuthError>
}
