//
//  MockAPIClient.swift
//  Atlas
//
//  Created by Parvin Sital on 25/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

final class MockAPIClient: APIClient {
    func fetch<R>(
        request: R,
        _ completion: @escaping (Result<Data, Error>) -> Void
    ) where R : Fetchable, R : Mockable {
        let data = getMock(mockable: request)
        completion(.success(data))
    }
    
    func getMock(mockable: Mockable) -> Data {
        let bundle = Bundle(for: MockAPIClient.self)
        let path = bundle.path(forResource: mockable.fileName!, ofType: mockable.extension)
        let url = URL(fileURLWithPath: path!)
        return try! Data(contentsOf: url)
    }
}
