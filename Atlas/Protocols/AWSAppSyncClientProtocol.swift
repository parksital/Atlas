//
//  AWSAppSyncClientProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 28/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync

protocol AWSAppSyncClientProtocol {
    func request<Q: GraphQLQuery>(
        query: Q,
        cachePolicy: CachePolicy,
        queue: DispatchQueue,
        resultHandler: ((JSONObject?, Error?) -> Void)?
    )
}

extension AWSAppSyncClient: AWSAppSyncClientProtocol {
    func request<Q: GraphQLQuery>(
        query: Q,
        cachePolicy: CachePolicy,
        queue: DispatchQueue,
        resultHandler: ((JSONObject?, Error?) -> Void)?
    ) {
        fetch(
            query: query,
            cachePolicy: cachePolicy,
            queue: queue
        ) { result, error in
            if let error = error {
                resultHandler?(nil, error)
            } else {
                guard let jsonObject = result?.data?.jsonObject else {
                    resultHandler?(nil, NetworkError.generic)
                    return
                }
                resultHandler?(jsonObject, nil)
            }
        }
    }
}
