//
//  AWSClient.swift
//  Atlas
//
//  Created by Parvin Sital on 05/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync

class AWSClient {
    private var appSyncClient: AWSAppSyncClient!
    
    init() {
        do {
            let appSyncConfig = try AWSAppSyncClientConfiguration(
                appSyncServiceConfig: AWSAppSyncServiceConfig(),
                cacheConfiguration: AWSAppSyncCacheConfiguration()
            )

            self.appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        } catch {
            assertionFailure("Error initializing appSyncClient. Error: \(error.localizedDescription)")
        }
    }

    func fetch<Q: GraphQLQuery>(query: Q, _ completion: @escaping (Result<Q.Data>) -> Void) {
        appSyncClient.fetch(
            query: query,
            cachePolicy: .returnCacheDataAndFetch,
            queue: .global(qos: .userInitiated)
        ) { (result, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = result?.data else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(data))
        }
    }
}
