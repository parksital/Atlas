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
        completion: ((Data?, Error?) -> Void)?
    )
}

extension AWSAppSyncClient: AWSAppSyncClientProtocol {
    func request<Q>(
        query: Q,
        completion: ((Data?, Error?) -> Void)?
    ) where Q : GraphQLQuery {
        fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: .global(qos: .userInitiated)) { result, error in
                if let error = error {
                    completion?(nil, error)
                } else {
                    guard let jsonObject = result?.data?.jsonObject else {
                        completion?(nil, NetworkError.generic)
                        return
                    }
                    // grab JSON and turn it into Data
                    let data = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    completion?(data, nil)
                }
        }
    }
}
