//
//  AWSContainer.swift
//  Atlas
//
//  Created by Parvin Sital on 28/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync
import Swinject

class AWSContainer {
    static let shared = AWSContainer()
    let container: Container
    
    private init() {
        container = Container()
        
        container.register(APIClientProtocol.self) { r in
            let appSyncClient = r.resolve(AWSAppSyncClientProtocol.self)!
            return AWSClient(appSyncClient: appSyncClient)
        }
        
        container.register(AWSAppSyncClientProtocol?.self) { r in
            do {
                let serviceConfig = try AWSAppSyncServiceConfig()
                let cacheConfig = try AWSAppSyncCacheConfiguration(
                    useClientDatabasePrefix: true,
                    appSyncServiceConfig: serviceConfig
                )
                
                let config = try AWSAppSyncClientConfiguration(
                    appSyncServiceConfig: serviceConfig,
                    cacheConfiguration: cacheConfig
                )
                
                return try AWSAppSyncClient(appSyncConfig: config)
            } catch {
                assertionFailure(error.localizedDescription)
                return nil
            }
        }
    }
}
