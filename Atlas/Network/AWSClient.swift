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

class AWSClient {
    private var appSyncClient: AWSAppSyncClientProtocol!
    private var decoder: JSONDecoder = JSONDecoder()
    
    init(appSyncClient: AWSAppSyncClientProtocol) {
        self.appSyncClient = appSyncClient
        
        do {
            let serviceConfig = try AWSAppSyncServiceConfig()
            let cacheConfig = try AWSAppSyncCacheConfiguration(useClientDatabasePrefix: true, appSyncServiceConfig: serviceConfig)
            
            let config = try AWSAppSyncClientConfiguration(appSyncServiceConfig: serviceConfig, cacheConfiguration: cacheConfig )
            self.appSyncClient = try AWSAppSyncClient(appSyncConfig: config)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

extension AWSClient {
    func fetch<Q: GraphQLQuery, D: Codable>(query: Q) -> Future<D, Error> {
        return Future<D, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.generic))
                return
            }
            
            self.appSyncClient.request(
                query: query,
                cachePolicy: .fetchIgnoringCacheData,
                queue: .global(qos: .userInitiated)) { result, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    } else {
                        guard let jsonObject = result else {
                            promise(.failure(NetworkError.generic))
                            return
                        }
                        do {
                            let object: D = try self.decode(D.self, with: jsonObject)
                            promise(.success(object))
                        } catch {
                            promise(.failure(NetworkError.generic))
                        }
                    }
            }
        }
    }
    
    private func decode<D: Codable>(_ type: D.Type, with json: JSONObject) throws -> D {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try decoder.decode(type, from: data)
    }
}
