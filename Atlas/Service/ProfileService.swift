//
//  ProfileService.swift
//  Atlas
//
//  Created by Parvin Sital on 20/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

final class ProfileService {
    private let sessionService: SessionService!
    private let client: APIClientProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionService: SessionService, client: APIClientProtocol) {
        self.sessionService = sessionService
        self.client = client
    }
    
    deinit { cancellables.forEach({ $0.cancel() }) }
    
}

private extension ProfileService {
    
}

extension ProfileService {
    func getCurrentUser() -> AnyPublisher<User, AuthError> {
        sessionService.getUID()
            .flatMap(self.getUser(byID:))
            .map({ $0.user })
            .eraseToAnyPublisher()
    }
    
    func getUser(byID id: String) -> AnyPublisher<GetUser, AuthError> {
        return client.fetch(query: Account.Request(id: id))
            .mapError(AuthError.init(error:))
            .eraseToAnyPublisher()
    }
}
