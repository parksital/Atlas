//
//  MockAPIClient.swift
//  Atlas
//
//  Created by Parvin Sital on 25/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync

final class MockAPIClient {
    func getMock(mockable: Mockable) -> Data {
        let bundle = Bundle(for: MockAPIClient.self)
        let path = bundle.path(forResource: mockable.fileName!, ofType: mockable.extension)
        let url = URL(fileURLWithPath: path!)
        return try! Data(contentsOf: url)
    }
}

extension MockAPIClient: AWSAppSyncClientProtocol {
    func request<Q: GraphQLQuery>(
        query: Q,
        completion: ((Data?, Error?) -> Void)?
    ) {
        
    }
}
