//
//  AWSContainer.swift
//  Atlas
//
//  Created by Parvin Sital on 28/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync
import AWSMobileClient
import Swinject

class AWSContainer {
    static let shared = AWSContainer()
    let container: Container
    
    private init() {
        container = Container()
        container.autoregister(APIClientProtocol.self, initializer: AWSClient.init)
        container.register(AWSAppSyncClientProtocol.self, factory: { _ in
            if ProcessInfo.processInfo.arguments.contains("mock") {
                return MockAPIClient()
            } else {
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
                    fatalError("could not initialise appsyncClient")
                }
            }
        })
        
        container.register(AuthClientProtocol.self) { _ in
            let client = AWSMobileClient.init()
            
            client.initialize { userSate, error in
                if let state = userSate {
                    print("userState: ", state)
                }
            }
            return client
        }.inObjectScope(.weak)
        
        container.autoregister(AuthService.self, initializer: AuthService.init)
    }
}
