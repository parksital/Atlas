//
//  AWSClient.swift
//  Atlas
//
//  Created by Parvin Sital on 05/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync
import Combine

protocol APIClientProtocol {
    func fetch<F: Fetchable & Mockable, D: Decodable>(query: F) -> Future<D, Error>
    func fetch<F: Fetchable & Mockable, D: Decodable>(query: F, cachePolicy: CachePolicy) -> Future<D, Error>
}

class AWSClient {
    private var appSyncClient: AWSAppSyncClientProtocol!
    private (set) var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init(appSyncClient: AWSAppSyncClientProtocol) {
        self.appSyncClient = appSyncClient
    }
}

extension AWSClient: APIClientProtocol {
    func fetch<F: Fetchable & Mockable, D: Decodable>(query: F) -> Future<D, Error> {
        fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
    }
    
    func fetch<F: Fetchable & Mockable, D: Decodable>(query: F, cachePolicy: CachePolicy = .fetchIgnoringCacheData) -> Future<D, Error> {
        return Future<D, Error> { [appSyncClient, decoder] promise in
            appSyncClient?.request(query: query, cachePolicy: cachePolicy) { result, error in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                
                guard let data = result else {
                    promise(.failure(NetworkError.generic))
                    return
                }
                
                do {
                    let object = try decoder.decode(D.self, from: data)
                    promise(.success(object))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
