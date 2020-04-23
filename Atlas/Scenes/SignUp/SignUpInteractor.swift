//
//  SignUpInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol SignUpLogic {
    
}

protocol SignUpDataStore {
    
}

typealias SignUpInteraction = SignUpLogic & SignUpDataStore
final class SignUpInteractor: SignUpDataStore {
    private var presenter: SignUpPresentationLogic!
    
    init(presenter: SignUpPresentationLogic) {
        self.presenter = presenter
    }
}

extension SignUpInteractor: SignUpLogic {
    
}
