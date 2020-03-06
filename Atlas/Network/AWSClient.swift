//
//  AWSClient.swift
//  Atlas
//
//  Created by Parvin Sital on 05/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync
import AWSMobileClient

// Make sure AWSMobileClient is a Cognito User Pool credentails providers
// this makes it easy to AWSMobileClient shared instance with AppSync Client
// read https://github.com/awslabs/aws-mobile-appsync-sdk-ios/issues/157 for details
extension AWSMobileClient: AWSCognitoUserPoolsAuthProviderAsync {
    public func getLatestAuthToken(_ callback: @escaping (String?, Error?) -> Void) {
        getTokens { (tokens, error) in
            if error != nil {
                callback(nil, error)
            } else {
                callback(tokens?.idToken?.tokenString, nil)
            }
        }
    }
}

class AWSClient {
    private var appSyncClient: AWSAppSyncClient!
    
    init() {
        do {
            let cacheConfiguration = try AWSAppSyncCacheConfiguration()
            
            // AppSync configuration & client initialization
            let appSyncServiceConfig = try AWSAppSyncServiceConfig()
            let appSyncConfig = try AWSAppSyncClientConfiguration(
                appSyncServiceConfig: appSyncServiceConfig,
                cacheConfiguration: cacheConfiguration
            )
            self.appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        } catch {
            assertionFailure("Error initializing appSyncClient. Error: \(error.localizedDescription)")
        }
    }

    func fetch<Q: GraphQLQuery>(
        query: Q,
        _ completion: @escaping (Result<Q.Data>) -> Void
    ) {
        appSyncClient.fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
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
