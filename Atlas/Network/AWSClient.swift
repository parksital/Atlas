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
    func fetch<Q: GraphQLQuery, D: Decodable>(query: Q) -> Future<D, Error>
}

class AWSClient {
    private var appSyncClient: AWSAppSyncClientProtocol!
    private var decoder: JSONDecoder = JSONDecoder()
    
    init(appSyncClient: AWSAppSyncClientProtocol) {
        self.appSyncClient = appSyncClient
    }
}

extension AWSClient: APIClientProtocol {
    func fetch<F: Fetchable & Mockable, D: Decodable>(query: F) -> Future<D, Error> {
        return Future<D, Error> { [appSyncClient, decoder] promise in
            appSyncClient?.request(query: query.query) { result, error in
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
    

    //MARK: - TODO: remove me after testing the fetchable+mockable function
    func fetch<Q: GraphQLQuery, D: Decodable>(query: Q) -> Future<D, Error> {
        return Future<D, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.generic))
                return
            }
            
            self.appSyncClient.request(query: query) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                } else {
                    guard let data = result else {
                        promise(.failure(NetworkError.generic))
                        return
                    }
                    do {
                        let object = try self.decoder.decode(D.self, from: data)
                        promise(.success(object))
                    } catch {
                        promise(.failure(NetworkError.generic))
                    }
                }
            }
        }
    }
}
