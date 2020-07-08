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
}

protocol PreferencesDataStore {
    
}

typealias PreferencesInteraction = PreferencesLogic & PreferencesDataStore
final class PreferencesInteractor: PreferencesLogic {
    private let presenter: PreferencesPresentationLogic!
    
    init(presenter: PreferencesPresentationLogic) {
        self.presenter = presenter
    }
}

extension PreferencesInteractor {
    func viewDidFinishLoading() {
        
    }
    
    func wipeKeychainButtonTapped() {
        presenter.presentAlert()
    }
}
