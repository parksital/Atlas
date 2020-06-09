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
        sessionService.cognitoSUB
            .compactMap({ $0 })
            .flatMap(profileService.getUserByID(id:))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: print("account interactor finished")
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            }, receiveValue: { [presenter] user in
                presenter?.presentUser(user)
            })
            .store(in: &cancellables)
    }
}

extension AccountInteractor: AccountLogic {
    func viewDidFinishLoading() {
        observe()
    }
    
    func goToSignUp() {
        presenter.goToSignUp()
    }
}
