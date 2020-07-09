//
//  AuthError.swift
//  Atlas
//
//  Created by Parvin Sital on 29/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case generic
    case signUpError
    case attributesError
    case noAppleUID
    case mapped(Error)
    
    init(error: Error) {
        self = .mapped(error)
    }
}

extension AuthError: Equatable {
    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
