//
//  PreferencesInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
protocol PreferencesLogic {
    func viewDidFinishLoading()
    func wipeKeychainButtonTapped()
    func checkPassphrase(_ passphrase: String)
}

protocol PreferencesDataStore {
    
}

typealias PreferencesInteraction = PreferencesLogic & PreferencesDataStore
final class PreferencesInteractor: PreferencesInteraction {
    private let presenter: PreferencesPresentationLogic!
    private let keychainManager: KeychainManagerProtocol!
    
    init(presenter: PreferencesPresentationLogic, keychainManager: KeychainManagerProtocol) {
        self.presenter = presenter
        self.keychainManager = keychainManager
    }
}

extension PreferencesInteractor {
    func viewDidFinishLoading() {
    }
    
    func wipeKeychainButtonTapped() {
        presenter.presentAlert()
    }
    
    func checkPassphrase(_ passphrase: String) {
        let encoded = passphrase.encodeToBase64()
        
        if keychainManager.tryWipe(passphrase: encoded) {
            presenter.presentWipeCompleted()
        } else {
            presenter.presentWipeFailure()
        }
    }
}
