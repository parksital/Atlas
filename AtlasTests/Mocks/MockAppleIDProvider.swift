//
//  MockAppleIDProvider.swift
//  AtlasTests
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AuthenticationServices

struct MockAppleIDProvider: AppleIDProviderProtocol {
    private let validUID = "david.appleid.uid"
    func getCredentialState(forUserID: String, completion: (AppleIDCredentialState, Error?) -> Void) {
        guard forUserID == validUID else {
            completion(.notFound, nil)
            return
        }
        
        completion(.authorized, nil)
    }
}
