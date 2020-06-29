//
//  AccountInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol AccountLogic: class {
    func viewDidFinishLoading()
    func goToSignUp()
}

protocol AccountDataStore {
    
}

typealias AccountInteraction = AccountLogic & AccountDataStore
final class AccountInteractor: AccountDataStore {
    private let presenter: AccountPresentationLogic!
    private let sessionService: SessionService!
    private let profileService: ProfileService!
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionService: SessionService, profileService: ProfileService, presenter: AccountPresentationLogic) {
        self.sessionService = sessionService
        self.profileService = profileService
        self.presenter = presenter
    }
    
    deinit { cancellables.forEach({ $0.cancel() }) }
}

private extension AccountInteractor {
    func observe() {
        sessionService.status
            .map({ $0 == .signedIn })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] signedIn in
                    if signedIn {
                        self?.getUser()
                    } else {
                        self?.presenter.presentUser(nil)
                    }
            }).store(in: &cancellables)
    }
    
    func getUser() {
        sessionService.cognitoSUB
            .filter({ !$0.isEmpty })
            .flatMap(profileService.getUserByID(id:))
            .sink(receiveCompletion: { _ in  },
                  receiveValue: presenter.presentUser(_:))
            .store(in: &cancellables)
    }
    
    func presentSettings() {
        presenter.presentSettings([
            "Saved",
            "History",
            "Preferences"
        ])
    }
}

extension AccountInteractor: AccountLogic {
    func viewDidFinishLoading() {
        observe()
        presentSettings()
    }
    
    func goToSignUp() {
        presenter.goToSignUp()
    }
}
