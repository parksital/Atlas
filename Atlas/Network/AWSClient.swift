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
            let serviceConfig = try AWSAppSyncServiceConfig()
            let cacheConfig = try AWSAppSyncCacheConfiguration(useClientDatabasePrefix: true, appSyncServiceConfig: serviceConfig)
            
            let config = try AWSAppSyncClientConfiguration(appSyncServiceConfig: serviceConfig, cacheConfiguration: cacheConfig )
            self.appSyncClient = try AWSAppSyncClient(appSyncConfig: config)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

extension AWSClient: APIClient {
    func fetch<R>(
        request: R,
        _ completion: @escaping (Swift.Result<Data, Error>) -> Void
    ) where R : Fetchable, R : Mockable {
        appSyncClient.fetch(
            query: request.query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: .global(qos: .userInteractive)
        ) { (result, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = result?.data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let finalData: Data = try JSONSerialization.data(withJSONObject: data.snapshot, options: .prettyPrinted)
                
                completion(.success(finalData))
            } catch {
                assertionFailure(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
