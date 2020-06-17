//
//  Keychained.swift
//  Atlas
//
//  Created by Parvin Sital on 17/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

@propertyWrapper struct Keychained {
    let key: String
    let storage = KeychainWrapper.standard
    var wrappedValue: String? {
        get { storage.string(forKey: key) }
        set {
            if let value = newValue {
                storage.set(value, forKey: key)
            }
        }
    }
}
