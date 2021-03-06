//
//  ProfileService.swift
//  Atlas
//
//  Created by Parvin Sital on 20/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol ProfileServiceProtocol {
    func getUserByID(id: String) -> AnyPublisher<User, Error>
}

final class ProfileService {
    private let client: APIClientProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    init(client: APIClientProtocol) {
        self.client = client
    }
    
    deinit { cancellables.forEach({ $0.cancel() }) }
    
}

private extension ProfileService {
    
}

extension ProfileService: ProfileServiceProtocol {
    func getUserByID(id: String) -> AnyPublisher<User, Error> {
        let f: Future<GetUser, Error> = client.fetch(query: Account.Request(id: id), cachePolicy: .returnCacheDataAndFetch)
        
        return f
            .map({ $0.user })
            .eraseToAnyPublisher()
    }
}

extension ProfileService {
    static func fixture() -> ProfileService {
        ProfileService(
            client: AWSClient(appSyncClient: MockAPIClient())
        )
    }
}
