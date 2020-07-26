//
//  AppleIDProviderProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AuthenticationServices

protocol AppleIDProviderProtocol {
    func getCredentialState(
        forUserID: String,
        completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void
    )
}

extension ASAuthorizationAppleIDProvider: AppleIDProviderProtocol { }
