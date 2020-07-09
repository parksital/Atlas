//
//  Keychained.swift
//  Atlas
//
//  Created by Parvin Sital on 17/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol KeychainManagerProtocol {
    var encodedPassphrase: String { get }
    
    func setValue(_ value: String, forKey key: String)
    func getValue(forKey key: String) -> String?
    func tryWipe(passphrase: String) -> Bool
}

final class MockKeychain: KeychainManagerProtocol {
    private var storage: [String: String] = [:]
    private (set) var encodedPassphrase: String = "Vm9sdA=="
    
    func setValue(_ value: String, forKey key: String) {
        storage[key] = value
    }
    func getValue(forKey key: String) -> String? {
        return storage[key]
    }
    
    func tryWipe(passphrase: String) -> Bool {
        if passphrase == encodedPassphrase {
            storage.removeAll()
            return true
        } else {
            return false
        }
    }
}

final class KeychainManager: KeychainManagerProtocol {
    private (set) var storage: KeychainWrapper! = .standard
    private (set) var encodedPassphrase: String = "Vm9sdA=="
    
    func setValue(_ value: String, forKey key: String) {
        storage.set(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> String? {
        storage.string(forKey: key)
    }
    
    func tryWipe(passphrase: String) -> Bool {
        if passphrase == encodedPassphrase {
            return storage.removeAllKeys()
        } else {
            return false
        }
    }
}

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
