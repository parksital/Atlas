//
//  AppleAuthData.swift
//  Atlas
//
//  Created by Parvin Sital on 29/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct AppleAuthData {
    let uid: String
    let email: String
    let fullName: PersonNameComponents
    let token: String
    
    var firstName: String {
        fullName.givenName!
    }
    
    var lastName: String {
        fullName.familyName!
    }
}

protocol AuthAttributes {
    var attributes: [String: String] { get }
}

extension AppleAuthData: AuthAttributes {
    var attributes: [String : String] {
        return [
            "family_name": lastName,
            "given_name": firstName
        ]
    }
}

extension AppleAuthData {
    static func fixture() -> AppleAuthData {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: "David Jefferson")!
        
        return AppleAuthData(
            uid: "david.appleid.uid",
            email: "david.appleid@domain.com",
            fullName: components,
            token: UUID().uuidString
        )
    }
}

