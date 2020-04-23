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
    func request<F: Fetchable & Mockable>(
        query: F,
        completion: ((Data?, Error?) -> Void)?
    )
}

extension AWSAppSyncClient: AWSAppSyncClientProtocol {
    func request<F: Fetchable & Mockable>(
        query: F,
        completion: ((Data?, Error?) -> Void)?
    ) {
        fetch(
            query: query.query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: .global(qos: .userInitiated)) { result, error in
                if let error = error {
                    completion?(nil, error)
                } else {
                    guard let jsonObject = result?.data?.jsonObject else {
                        completion?(nil, NetworkError.generic)
                        return
                    }
                    
                    let data = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    completion?(data, nil)
                }
        }
    }
}
