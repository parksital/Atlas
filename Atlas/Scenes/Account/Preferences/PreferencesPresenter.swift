//
//  PreferencesPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol PreferencesPresentationLogic {
    func setup(viewController: PreferencesDisplayLogic)
    func presentAlert()
}

final class PreferencesPresenter {
    private weak var viewController: PreferencesDisplayLogic?
    
    init() {
        
    }
}

extension PreferencesPresenter: PreferencesPresentationLogic {
    func setup(viewController: PreferencesDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentAlert() {
        viewController?.displayAlert()
    }
}
